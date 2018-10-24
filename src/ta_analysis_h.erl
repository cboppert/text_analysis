-module(ta_analysis_h).
-behavior(cowboy_rest).

-export([init/2,
         known_methods/2, content_types_accepted/2,
         allowed_methods/2]).

-export([to_json/2]).

% TODO: Use types
-type analysis() :: #{
        gender := male | female | unknown,
        duration := 0 | pos_integer(),
        sentiment := positive | negative | mixed
       }.
-define(ParagraphKey, <<"paragraph">>).

-export_type([analysis/0]).

init(Req, State) ->
   {cowboy_rest, Req, State}.

content_types_accepted(Req, State) ->
   {[
     {<<"application/json">>, to_json}
    ], Req, State}.

known_methods(Req, State) ->
   {[<<"POST">>], Req, State}.

allowed_methods(Req, State) ->
   {[<<"POST">>], Req, State}.

analysis_map(Gender, Duration, Sentiment) ->
   #{gender => Gender, duration => Duration, sentiment => Sentiment}.

to_json(Req, State) ->
   {ok, Data, _Req} = cowboy_req:read_body(Req),
   BodyMap = jsx:decode(Data, [return_maps]),
   Text = maps:get(?ParagraphKey, BodyMap),
   Gender = gender_analysis:analyze(Text),
   Duration = 12,
   Sentiment = gender_analysis:analyze(Text),
   AnalysisMap = analysis_map(Gender, Duration, Sentiment),
   Json = jsx:encode(AnalysisMap),
   {ok, Res} = cowboy_req:reply(200, #{
     <<"content-type">> => <<"application/json">>
    }, Json, Req),
   {true, Res, State}.

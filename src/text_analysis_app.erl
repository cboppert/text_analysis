-module(text_analysis_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
   Dispatch = cowboy_router:compile([{'_', [{"/health", ta_health_h, []},
                                            {"/analysis", ta_analysis_h, []}]}]),
   {ok, _} = cowboy:start_clear(ta_http_listener,
                                [{port, 8090}],
                                #{env => #{dispatch => Dispatch}}),
   text_analysis_sup:start_link().

stop(_State) ->
   ok.

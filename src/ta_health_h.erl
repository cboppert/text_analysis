-module(ta_health_h).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
     Req = cowboy_req:reply(200,
                            #{<<"content-type">> => <<"text/plain">>},
                            <<"I'm alive">>,
                            Req0),
       {ok, Req, State}.

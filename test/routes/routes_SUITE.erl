-module(routes_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([health_test/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUITE                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
all() -> [health_test].

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init and teardown       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
init_per_suite(Config) ->
   {ok, AppStartList} = start([text_analysis]),
   inets:start(),
   [{app_start_list, AppStartList}|Config].

end_per_suite(Config) ->
   inets:stop(),
   stop(?config(app_start_list, Config)),
   Config.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% route tests             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
health_test(_Config) ->
   {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
      httpc:request(get, {"http://localhost:8090/health", []}, [], []),
   Body = "I'm alive".


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper functions        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(Apps) ->
   {ok, do_start(Apps, [])}.

do_start([], Started) ->
   Started;
do_start([App|Apps], Started) ->
   case application:start(App) of
      ok ->
         do_start(Apps, [App|Started]);
      {error, {not_started, Dep}} ->
         do_start([Dep|[App|Apps]], Started)
      end.

stop(Apps) ->
   _ = [ application:stop(App) || App <- Apps ],
   ok.

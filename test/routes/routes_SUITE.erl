-module(routes_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0, groups/0, init_per_suite/1, end_per_suite/1]). %,
        %init_per_testcase/2, end_per_testcase/2]).
-export([health_test/1, analysis_test_paragraph_one/1,
         analysis_test_paragraph_two/1]).

-define(Host, "127.0.0.1").
-define(Port, 8090).
-define(HealthCheckRoute, "/health").
-define(AnalysisRoute, "/analysis").
-define(ParagraphOne, <<"John downloaded the Pokemon Go app on 07/15/2017. By 07/22/2017, he was on level 24. Initially, he was very happy with the app. However, he soon became very disappointed with the app because it was crashing very often. As soon as he reached level 24, he uninstalled the app.">>).
-define(ParagraphTwo, <<"Hua Min liked playing tennis. She first started playing on her 8th birthday - 07/07/1996. Playing tennis always made her happy. She won her first tournament on 08/12/2010. However, on 04/15/2015 when she was playing at the Flushing Meadows, she had a serious injury and had to retire from her tennis career.">>).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUITE                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
all() -> [{group, routes_group}].
groups() -> [{routes_group,
              [parallel, {repeat, 1}],
              [health_test, analysis_test_paragraph_one,
              analysis_test_paragraph_two]}].

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init and teardown       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
init_per_suite(Config) ->
   {ok, AppStartList} = start([text_analysis]),
   [{app_start_list, AppStartList}|Config].

end_per_suite(Config) ->
   stop(?config(app_start_list, Config)),
   Config.

%init_per_testcase(routes_group, Config) ->
%   ct:pal("Config IPTC: ~p~n", [Config]),
%   {ok, Conn} = shotgun:open(?Host, ?Port),
%   [{connection, Conn}|Config].
%
%end_per_testcase(routes_group, Config) ->
%   ct:pal("Config EPTC: ~p~n", [Config]),
%   shotgun:close(?config(connection, Config)),
%   stop(?config(app_start_list, Config)),
%   ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% route tests             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
health_test(_Config) ->
   {ok, Conn} = shotgun:open(?Host, ?Port),
   %{ok, Response} = shotgun:get(?config(connection, Config), ?HealthCheckRoute),
   {ok, #{body := Body}} = shotgun:get(Conn, ?HealthCheckRoute),
   shotgun:close(Conn),
   Body = <<"I'm alive">>.

analysis_test_paragraph_one(_Config) ->
   {ok, Conn} = shotgun:open(?Host, ?Port),
   Headers = #{<<"content-type">> => <<"application/json">>},
   Body = jsx:encode(#{paragraph => ?ParagraphOne}),
   %{ok, Response} = shotgun:post(?config(connection, Config),
   {ok, #{body := ResponseBody}} = shotgun:post(Conn,
                                 ?AnalysisRoute,
                                 Headers,
                                 Body,
                                 #{}),
   shotgun:close(Conn),
   ResponseBody = jsx:encode(#{gender => <<"male">>,
                              duration => 8,
                              sentiment => <<"mixed">>}).

analysis_test_paragraph_two(_Config) ->
   {ok, Conn} = shotgun:open(?Host, ?Port),
   Headers = #{<<"content-type">> => <<"application/json">>},
   Body = jsx:encode(#{paragraph => ?ParagraphTwo}),
   {ok, #{body := ResponseBody}} = shotgun:post(Conn,
                                 ?AnalysisRoute,
                                 Headers,
                                 Body,
                                 #{}),
   shotgun:close(Conn),
   ResponseBody = jsx:encode(#{gender => <<"female">>,
                               duration => 6857,
                               sentiment => <<"positive">>}).


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

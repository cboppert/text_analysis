-module(text_analysis_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
   supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
   RestartStrategy = {one_for_one, 1, 5},
   Procs = [{analysis_sup_s,
             {analysis_sup, start_link, []},
            permanent,
            1000,
            supervisor,
            [analysis_sup]}],
   {ok, {RestartStrategy, Procs}}.

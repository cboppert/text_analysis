-module(analysis_sup).
-behavior(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
   supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
   RestartStrategy = {one_for_one, 1, 5},
   Procs = [{gender_analysis_p,
             {gender_analysis, start_link, []},
            permanent,
            brutal_kill,
            worker,
            [gender_analysis]},
            {sentiment_analysis_p,
             {sentiment_analysis, start_link, []},
            permanent,
            brutal_kill,
            worker,
            [sentiment_analysis]}],
   {ok, {RestartStrategy, Procs}}.

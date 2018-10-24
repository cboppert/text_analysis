-module(date_analysis).
-behavior(gen_server).
% gen_server
-export([init/1, handle_call/3, start_link/0]).
% unused gen_server but required
-export([handle_cast/2, handle_info/2]).
% my module
-export([analyze/1]).

-define(HePattern, "\\b[H,h]e\\b").
-define(ShePattern, "\\b[S,s]he\\b").

analyze(Text) ->
   gen_server:call(?MODULE, {analyze, Text}).

handle_call({analyze, _Text}, _From, _State) -> true.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, none, []).

init(_) -> {ok, []}.

% Not used
handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.

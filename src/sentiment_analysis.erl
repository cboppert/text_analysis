-module(sentiment_analysis).
-behavior(gen_server).
% gen_server
-export([init/1, handle_call/3, start_link/0]).
% unused gen_server but required
-export([handle_cast/2, handle_info/2]).
% my module
-export([analyze/1]).

-define(PositivePattern, "\\b(happy|glad|jubilant|satisfied)\\b").
-define(NegativePattern, "\\b(sad|dissapointed|angry|frustrated)\\b").

analyze(Text) ->
   gen_server:call(?MODULE, {analyze, Text}).

check_for_sentiment(Text, Pattern) ->
   case re:run(Text, Pattern) of
      {match, _} -> true;
      nomatch -> false
   end.

check_if_positive(Text) ->
   check_for_sentiment(Text, ?PositivePattern).

check_if_negative(Text) ->
   check_for_sentiment(Text, ?NegativePattern).

handle_call({analyze, Text}, _From, State) ->
   Reply = case {check_if_positive(Text), check_if_negative(Text)} of
              {true, true} -> mixed;
              {true, false} -> positive;
              {false, true} -> negative;
              {false, false} -> unknown
   end,
   {reply, Reply, State}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, none, []).

init(_) -> {ok, []}.

% Not used
handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.

-module(date_analysis).
-behavior(gen_server).
% gen_server
-export([init/1, handle_call/3, start_link/0]).
% unused gen_server but required
-export([handle_cast/2, handle_info/2]).
% my module
-export([analyze/1]).
-export([get_dates/1, min_and_max_dates/1, min_and_max_dates/2]).

-define(DatePattern, "\\b\\d{2}/\\d{2}/\\d{4}\\b").

analyze(Text) ->
   gen_server:call(?MODULE, {analyze, Text}).

% Returns [] or list of date strings
get_dates(Text) ->
   io:format("~p~n", [re:run(Text, ?DatePattern, [global, {capture, first}])]),
   case re:run(Text, ?DatePattern, [global, {capture, first}]) of
      nomatch -> [];
      {match, Dates} -> lists:map(fun([{Index, Length}|[]]) ->
                                        edate:string_to_date(
                                           string:slice(Text, Index, Length))
                                  end, Dates)
   end.

min_and_max_dates([]) -> #{min => unknown, max => unknown};
min_and_max_dates([Date]) -> #{min => Date, max => unknown};
min_and_max_dates(Dates) -> min_and_max_dates(Dates, #{}).

min_and_max_dates([], Map) -> Map;
min_and_max_dates([Date|Rest], Map) when map_size(Map) == 0 ->
   min_and_max_dates(Rest, #{min => Date});
min_and_max_dates([Date|Rest], #{min := Min} = Map) when map_size(Map) == 1 ->
   case edate:subtract(Date, Min) of
      Diff when Diff > 0 -> min_and_max_dates(Rest,
                                              #{min => Min, max => Date});
      _Diff -> min_and_max_dates(Rest, #{min => Date, max => Min})
   end;
min_and_max_dates([Date|Rest], #{min := Min, max := Max}) ->
   SubtractMin = edate:subtract(Min, Date),
   SubtractMax = edate:subtract(Date, Max),
   if
      SubtractMin > 0 -> min_and_max_dates(Rest,
                                           #{min => Date, max => Max});
      SubtractMax > 0 -> min_and_max_dates(Rest,
                                           #{min => Min, max => Max});
      true -> min_and_max_dates(Rest, #{min => Min, max => Max})
   end.

handle_call({analyze, Text}, _From, State) ->
   Reply = case min_and_max_dates(get_dates(Text)) of
      #{min := unknown, max := unknown} -> unknown;
      #{min := _Date, max := unknown} -> 1;
      #{min := Min, max := Min} -> 1;
      #{min := Min, max := Max} -> edate:subtract(Max, Min) + 1
   end,
   {reply, Reply, State}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, none, []).

init(_) -> {ok, []}.

% Not used
handle_cast(_Message, State) -> {noreply, State}.
handle_info(_Message, State) -> {noreply, State}.

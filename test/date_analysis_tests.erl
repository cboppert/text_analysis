-module(date_analysis_tests).
-include_lib("eunit/include/eunit.hrl").

one_date_test(Text) ->
   ?_assertEqual(1, date_analysis:analyze(Text)).

two_dates_test(Text) ->
   ?_assertEqual(10, date_analysis:analyze(Text)).

many_dates_test(Text) ->
   ?_assertEqual(10, date_analysis:analyze(Text)).

no_dates_test(Text) ->
   ?_assertEqual(unknown, date_analysis:analyze(Text)).

date_analysis_test_() ->
   {"Tests the date analysis module for one date,
   two dates, many dates, and zero dates",
    {foreach,
     fun start/0,
     fun stop/1,
     [one_date_test("It was 10/10/2010."),
      two_dates_test("Between 10/10/2010 and 10/20/2010."),
      many_dates_test("It occurred on 10/10/2010, 10/30/2010, and 10/20/2010."),
      no_dates_test("Nothing ever happened.")]}}.

start() ->
   date_analysis:start_link().

stop(_) ->
   ok.

-module(gender_analysis_tests).
-include_lib("eunit/include/eunit.hrl").

male_test(Text) ->
   ?_assertEqual(male, gender_analysis:analyze(Text)).

female_test(Text) ->
   ?_assertEqual(female, gender_analysis:analyze(Text)).

unknown_test(Text) ->
   ?_assertEqual(unknown, gender_analysis:analyze(Text)).

unknown_with_pronouns_test(Text) ->
   ?_assertEqual(unknown, gender_analysis:analyze(Text)).

gender_analysis_test_() ->
   {"Tests the gender analysis module for male, female, unknown
   without pronouns, and unknown with pronouns",
    {foreach,
     fun start/0,
     fun stop/1,
     [male_test("He went to the store"),
      female_test("She gave him the list"),
      unknown_test("And the rest is history"),
      unknown_with_pronouns_test("Now he is married and she is the one.")]}}.

start() ->
   gender_analysis:start_link(),
   ok.

stop(_) ->
   ok.

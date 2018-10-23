-module(gender_analysis).
-export([analyze/1]).

-define(HePattern, "\\b[H,h]e\\b").
-define(ShePattern, "\\b[S,s]he\\b").

analyze(Text) ->
   case {check_if_male(Text), check_if_female(Text)} of
      {true, true} -> unknown;
      {true, false} -> male;
      {false, true} -> female;
      {false, false} -> unknown
   end.

check_if_male(Text) ->
   check_gender(Text, ?HePattern).

check_if_female(Text) ->
   check_gender(Text, ?ShePattern).

check_gender(Text, Pattern) ->
   case re:run(Text, Pattern) of
      {match, _} -> true;
      nomatch -> false
   end.

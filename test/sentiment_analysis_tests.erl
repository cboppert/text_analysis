-module(sentiment_analysis_tests).
-include_lib("eunit/include/eunit.hrl").

positive_sentiment_test(Text) ->
   ?_assertEqual(positive, sentiment_analysis:analyze(Text)).

negative_sentiment_test(Text) ->
   ?_assertEqual(negative, sentiment_analysis:analyze(Text)).

unknown_sentiment_test(Text) ->
   ?_assertEqual(unknown, sentiment_analysis:analyze(Text)).

mixed_sentiment_test(Text) ->
   ?_assertEqual(mixed, sentiment_analysis:analyze(Text)).

sentiment_analysis_test_() ->
   {"Tests the sentiment analysis module for positive, negative,
   mixed, and unknown sentiments",
    {foreach,
     fun start/0,
     fun stop/1,
     [positive_sentiment_test("He was happy, no, he was jubilent"),
      negative_sentiment_test("They were sad and disappointed"),
      unknown_sentiment_test("But who are we talking about?"),
      mixed_sentiment_test("I mean everyone's happy and sad at some point.")]}}.

start() ->
   sentiment_analysis:start_link(),
   ok.

stop(_) ->
   ok.

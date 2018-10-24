# Text Analysis with JavaScript for COTA Healthcare

## Goals

### Semantic Analysis

Given a text such as

"John downloaded the Pokemon Go app on 07/15/2017. By 07/22/2017, he was on level 24. Initially, he was very happy with the app. However, he soon became very disappointed with the app because it was crashing very often. As soon as he reached level 24, he uninstalled the app."

Look for the following positive keywords
happy, glad, jubilant, satisfied

and the following negative keywords
sad, dissapointed, angry, and frustrated

to determine the sentiment of the text.

Sentiments are output as positive, negative, mixed, or unknown.

### Time Duration
Look for dates in the format MM/DD/YYYY and return the difference (inclusive) between the earliest and latest date.
If there is only one date assume a duration of 1. If there are none then 0. If there are more than two output the difference between the latest and earliest.

### Gender
Look for pronouns such as he and she and output male, female or unknown.
Unknown when both are found, and unknown when none are found.

## Running the tests
The tests exist in the test directory and must be run using make or gmake (on OS X)

   gmake ct

Running with ct_run will not start the application and the tests will fail.

Running with

   gmake tests

should run unit tests as well

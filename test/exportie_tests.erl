-module(exportie_tests).
-compile({parse_transform,exportie}).
-include_lib("eunit/include/eunit.hrl").

export(f(1)) ->
    1;
export(f(2)) ->
    2;
export(f({A})) ->
    A;
export(f(A)) ->
    A.

export(z()) ->
    1.

export(c(A)) when A == 1 ->
    yes;
export(c(A)) when A == 2 ->
    no.


simple_test() -> 
    ?assertEqual(1,?MODULE:f(1)),
    ?assertEqual(2,?MODULE:f(2)),
    ?assertEqual(3,?MODULE:f(3)),
    ?assertEqual(3,?MODULE:f({3})),
    ?assertEqual(1,?MODULE:z()).
    
guard_test() ->
    ?assertEqual(yes,?MODULE:c(1)),
    ?assertEqual(no,?MODULE:c(2)).
    

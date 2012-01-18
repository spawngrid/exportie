-module(exportie_custom).
-compile({parse_transform,exportie}).
-include_lib("eunit/include/eunit.hrl").
-exportie(' ').

' '(f()) ->
    1.

Exportie
========

Problem
-------

At times it feels very tiresome to jump up to the file's header to update your `-export`
attribute whenever you change arity, add or remove functions.

Solution
--------

While there are some solutions available to address this, such as developing text editor macros, this might not be suitable for everybody.

Exportie offers a different, yet simple, solution to this problem.

Exportie is a parse transformation that will convert your code from this:

```erlang
export@(f(A)) when is_list(A) ->
     A;
export@(f(A)) when is_binary(A) ->
     [A].
```

to this:

```erlang
-export([f/1]).

%% ...

f(A) when is_list(A) ->
     A;
f(A) when is_binary(A) ->
     [A].
```

That's it! All you have to do to enable this is to add this line below to your module:

```erlang
-compile({parse_transform, exportie}).
```

Neat, eh?

Extra Goodies
-------------

### Customizable export@

Don't like `export@` syntax? No problem. Exportie allows you to customize this, just use `-exportie` module attribute to define one:

```erlang
-exportie(' ').

' '(f(A)) -> A.
```          


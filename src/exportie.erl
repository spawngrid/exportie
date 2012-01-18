-module(exportie).
-export([parse_transform/2]).

-record(state, 
        {
          function_name,
          arity,
          exports = [],
          options
        }).

parse_transform(Forms, Options) ->
    {Forms1, State} = parse_trans:transform(fun do_transform/4, 
                                             #state{ options = Options },
                                             Forms, Options),
    Forms2 = lists:foldl(fun({M,A},Acc) ->
                                 parse_trans:export_function(M,A,Acc)
                         end, Forms1, State#state.exports),
    Result = parse_trans:revert(Forms2),
%    io:format("~s~n",[[ erl_pp:form(F) || F <- Result]]),
    Result.

transform(Fun, State, Form, Context) when is_tuple(Form) ->
    {L,Rec,State1} = transform(Fun, State, [Form], Context),
    {hd(L),Rec,State1};

transform(Fun, State, Forms, Context) when is_list(Forms) ->
    {Form1, State1} = parse_trans:do_transform(Fun,
                                               State,
                                               Forms, 
                                               Context),
    {parse_trans:revert(Form1),false,State1}.

do_transform(function,{function, Line, export@, 1, Cs}, Context, 
             #state{ exports = Exports} = State) ->
    {Cs1, _Rec, State1} = transform(fun export_transform/4, State, Cs, Context),
    Form = {function, Line, State1#state.function_name, State1#state.arity, Cs1},
    {Form, false, State#state{
                    exports = [{State1#state.function_name, State1#state.arity}|Exports]
                   }};

do_transform(_Type, Form, _Context, State) ->
    {Form, true, State}.

export_transform(clause,{clause, Line, H, G, B}, Context, State) ->
    {H1, Rec, State1} = 
        transform(fun export_transform/4, State, H, Context),
    
    {{clause, Line, H1, G, B}, Rec, State1};

export_transform(application,{call, _Line, {atom, _, Name}, Args}, _Context,
                 #state{} = State) ->
    {Args, false, State#state{ function_name = Name, arity = length(Args) }};

export_transform(_Type, Form, _Context, State) ->
    {Form, true, State}.

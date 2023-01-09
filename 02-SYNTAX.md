# Tour of `iex`

Elixir is a strange Lisp!

```elixir

steps = [
    {3, "Tm93IHRyeSBkZWZpbmluZyBhIGZ1bmNpdG9uLg=="},
    {4, "SSBob3BlIHlvdSBoYXZlIGVuam95ZWQgdGhlIHR1dG9yaWFsLg=="},
    {1, "SW4gaWV4LCB5b3UgY2FuIGVudGVyIEVsaXhpciB0ZXJtcywgY2FsbCBtYWNyb3MgYW5kIGZ1bmN0aW9ucy4="},
    {2, "VHJ5IGRlZmluZSBzb21lIHRlcm0uIFdoaWNoIHRlcm0gZGlkIHlvdSBkZWZpbmU/"},
]

defmodule(Tutorial, [do: (
    for({step_id, msg} <- steps, [do:
        if(step_id != length(steps), [
            do:
                (def step(unquote(step_id)), [do:
                    IO.puts(unquote(Base.decode64!(msg)))
                ]),
            else:
                (def step_final(), [do:
                    IO.puts(unquote(Base.decode64!(msg)))
                ])
        ])
    ])
    def step(_), [do: step_final()]
)])
```

## Defining a function in iex?

```
def f(x), do: x
```

Will complain with a stacktrace!

```
f = fn x -> x end
```

Will work. You'll have to punctuate the function call for Elixir to understand that you're trying to call a function bound to a variable: `f.(5)`.

There's a long story about this is the case, but it is a combination of factors from the fact that **named** functions in Erlang aren't quite first class:

```
5> erlang:apply(erlang:apply, [Af, [42]]).
* 1:14: illegal expression
6> erlang:apply(fun (X, Y) -> erlang:apply(X, Y) end, [Af, [42]]).
```

As well as the fact that Elixir has a lot of necessary syntactic sugars which would interfere with variable function disambiguation.

Which brings us to the subject of Elixir having almost no magic.

# Almost no magic

```elixir
defmodule Sugar do
    for {step_id, msg} <- steps do
        if step_id != length steps do

            def step(unquote(step_id)) do
                IO.puts unquote(Base.decode64! msg)
            end

        else

            def step_final() do
                IO.puts unquote(Base.decode64! msg)
            end

        end
    end

    def step(_), do: step_final()
end
```

# Appendix

## All the special forms

```
λ ../s defmacro | rg special
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacrop error!(args) do
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:{})(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:%{})(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:%)(struct, map), do: error!([struct, map])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:<<>>)(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:.)(left, right), do: error!([left, right])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro alias(module, opts), do: error!([module, opts])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro require(module, opts), do: error!([module, opts])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro import(module, opts), do: error!([module, opts])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro __ENV__, do: error!([])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro __MODULE__, do: error!([])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro __DIR__, do: error!([])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro __CALLER__, do: error!([])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro __STACKTRACE__, do: error!([])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro ^var, do: error!([var])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro left = right, do: error!([left, right])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro left :: right, do: error!([left, right])
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro squared(x) do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro squared(x) do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro squared(x) do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro no_interference do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro interference do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro write do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro read do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro write do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro read do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro no_interference do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro no_interference do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro no_interference do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro interference do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacrop get_length do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacrop get_length do
elixir/lib/elixir/lib/kernel/special_forms.ex:        defmacro defadd do
elixir/lib/elixir/lib/kernel/special_forms.ex:      defmacro defkv(kv) do
elixir/lib/elixir/lib/kernel/special_forms.ex:      defmacro defkv(kv) do
elixir/lib/elixir/lib/kernel/special_forms.ex:      defmacro defkv(kv) do
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro quote(opts, block), do: error!([opts, block])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:unquote)(expr), do: error!([expr])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:unquote_splicing)(expr), do: error!([expr])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro for(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro with(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:fn)(clauses), do: error!([clauses])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:__block__)(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:&)(expr), do: error!([expr])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro unquote(:__aliases__)(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro super(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro case(condition, clauses), do: error!([condition, clauses])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro cond(clauses), do: error!([clauses])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro try(args), do: error!([args])
elixir/lib/elixir/lib/kernel/special_forms.ex:  defmacro receive(args), do: error!([args])
```

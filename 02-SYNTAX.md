# Tour of `iex`

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

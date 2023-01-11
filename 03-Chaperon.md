# Declarative computation

The pinnacle of declarative computation is to set it up in one place and run it in another.
It allows for composability and for great separation of concerns.
This is a standard funcitonal programming design pattern and you'll see it everywhere, including Phoenix and Ecto.

We'll learn it on example of Chaperon.

```
> LoadTestScenario.init(%Chaperon.Session{})
{:ok,
 %Chaperon.Session{
   assigned: %{interval: 1000, rate: 15},
   async_tasks: %{},
   cancellation: nil,
   config: %{},
   cookies: [],
   errors: %{},
   id: nil,
   interval_task: nil,
   metrics: %{},
   name: nil,
   parent_id: nil,
   parent_pid: nil,
   results: %{},
   scenario: nil,
   timeout_at: nil
 }}
```

## Run as a test!

```
Chaperon.run_load_test LoadTest, output: "metrics.json", format: :json
x = %Chaperon.Action.HTTP{
    body: "",
    callback: nil,
    decode: nil,
    headers: %{"Accept" => "*/*", "User-Agent" => "chaperon"},
    method: :get,
    metrics_url: nil,
    params: %{},
    path: "/"
}
v(1).errors[x] |> length
```

# Test from another node

```
iex --cookie dangerZone420 --name "doa@172.17.158.204" -S mix
```

# In Erlang to launch observer:

```
net_kernel:start(['obs@172.17.144.1']).
erlang:set_cookie('dangerZone420').
net_adm:ping('doa@172.17.158.204').
erlang:nodes().
observer:start().
```

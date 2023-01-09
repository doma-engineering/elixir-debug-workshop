defmodule DayOne do
  @moduledoc """
  Documentation for `DayOne`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DayOne.hello()
      :world

  """
  def hello do
    :world
  end

  require Logger

  def step(1) do
    Logger.info("Let's start with writing a HTTP server as a wrapper around Erlang's :gen_tcp.")
    Logger.info("We'll be running it from iex first.")
    Logger.info("We can do it by runing `iex -S mix`, which will launch iex session which is aware of the current mix project.")
  end

  def step(_) do
    Logger.info("I hope you enjoyed this part of the workshop!")
  end
end

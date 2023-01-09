defmodule DayOneAppTest do
  use ExUnit.Case
  doctest DayOneApp

  test "greets the world" do
    assert DayOneApp.hello() == :world
  end
end

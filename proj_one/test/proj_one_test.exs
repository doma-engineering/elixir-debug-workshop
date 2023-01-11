defmodule ProjOneTest do
  use ExUnit.Case
  doctest ProjOne

  test "greets the world" do
    assert ProjOne.hello() == ["wo", "rld"]
  end
end

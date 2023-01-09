defmodule OnTheMap do
  @moduledoc """
  OnTheMap keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # A function that provides information about this library.
  @spec info :: String.t()
  def info do
    """
    OnTheMap is a library that provides the contexts that define your domain
    and business logic.

    Contexts are also responsible for managing your data, regardless
    if it comes from the database, an external API or others.
    """
  end
end

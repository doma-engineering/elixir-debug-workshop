defmodule OnTheMap.Auth do
  @moduledoc """
  Authentication-related logic
  """
  
  import Ecto.Query
  alias OnTheMap.Repo
  alias OnTheMap.Auth.Identity

  @spec get_identity_by_id(String.t()) :: Identity.st() | nil
  def get_identity_by_id(id), do: id |> identity_id_query() |> Repo.one()

  @spec identity_exists?(String.t()) :: boolean
  def identity_exists?(id), do: id |> identity_id_query() |> Repo.exists?()

  @spec id(Identity.st()) :: String.t()
  def id(%Identity{secret: secret}) do
    <<head::binary-size(4)>> <> _rest = secret

    head
  end

  @spec create_identity(identity_params :: map) :: {:ok, Identity.st()} | {:error, Ecto.Changeset.t()}
  def create_identity(identity_params) do
    %Identity{}
    |> Identity.changeset(identity_params)
    |> Repo.insert()
  end

  @spec generate_challenge(Identity.st()) :: {:ok, Identity.st()} | {:error, Ecto.Changeset.t()}
  def generate_challenge(%Identity{} = identity) do
    identity
    |> Identity.challenge_changeset(%{challenge: Enum.random(4..1024)})
    |> Repo.update()
  end

  @spec valid_signature?(Identity.st(), String.t()) :: boolean
  def valid_signature?(%Identity{secret: secret, challenge: challenge}, signature) do
    String.at(secret, challenge) === signature
  end

  @spec identity_id_query(String.t()) :: Ecto.Query.t()
  defp identity_id_query(id) do
    from identity in Identity, where: fragment("starts_with(?, ?)", identity.secret, ^id)
  end
end

defmodule OnTheMap.Crypto.Eff do
  @moduledoc """
  OnTheMap.Crypto.Eff provides facilities to run side-effects related to Crypto.Identity structure.
  """

  alias OnTheMap.Repo
  alias OnTheMap.Crypto
  alias OnTheMap.Crypto.Identity

  alias Uptight.Result
  alias Uptight.Base, as: B
  alias Uptight.Text, as: T

  import Ecto.Query, only: [from: 2]
  # import Witchcraft.Functor

  # Side-effecting stuff

  @doc """
  Returns the identity associated with the provided public key.
  """
  @spec get_identity_by_id(T.t()) :: any
  def get_identity_by_id(%T{} = pk) do
    pk |> T.un() |> identity_pk_query() |> Repo.one()
  end

  @doc """
  Returns true if the provided public key is associated with an identity, false otherwise.
  """
  @spec identity_exists?(T.t()) :: boolean
  def identity_exists?(%T{} = pk) do
    pk |> T.un() |> identity_pk_query() |> Repo.exists?()
  end

  # Raw stuff

  @spec id!(Identity.st()) :: B.Urlsafe.t()
  def id!(%Identity{pk: pk}) do
    pk |> B.mk_url!()
  end

  @spec id(Identity.st()) :: Result.t()
  def id(%Identity{pk: pk}) do
    pk |> B.mk_url()
  end

  @doc """
  Never use this function in safe code.
  Only use it for interfacing with non-Uptight interfaces.
  """
  @spec raw_id64(Identity.st()) :: String.t()
  def raw_id64(%Identity{pk: pk}) do
    pk
  end

  @spec create_identity(map()) :: {:ok, Identity.st()} | {:error, Ecto.Changeset.t()}
  def create_identity(identity_params) do
    %Identity{}
    |> Identity.changeset(identity_params)
    |> Repo.insert()
  end

  # Random eight-byte challenge. It is a raw string!
  @spec mk_challenge() :: String.t()
  def mk_challenge() do
    # Using libsodium here may be a better idea.
    :crypto.strong_rand_bytes(8) |> Base.encode64()
  end

  @spec generate_challenge(Identity.st()) :: {:ok, Identity.st()} | {:error, Ecto.Changeset.t()}
  def generate_challenge(%Identity{} = identity) do
    identity
    |> Identity.challenge_changeset(%{challenge: mk_challenge()})
    |> Repo.update()
  end

  @spec is_valid_signature!(Identity.st(), B.Urlsafe.t()) :: boolean()
  def is_valid_signature!(
        %Identity{pk: pk, challenge: challenge},
        %B.Urlsafe{} = signature
      ) do
    sig = %{signature: signature, public: pk |> B.mk_url!()}
    challenge |> T.new!() |> Crypto.verify(sig)
  end

  defp identity_pk_query(raw_pk64) do
    from i in Identity, where: i.pk == ^raw_pk64
  end
end

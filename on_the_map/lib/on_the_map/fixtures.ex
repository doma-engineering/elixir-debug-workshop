defmodule OnTheMap.Fixtures do
  @moduledoc """
  Generate random identities for testing.
  And other fixtures.
  """

  alias Uptight.Binary
  alias Uptight.Base, as: B

  ## Baked-in main key.
  def main_key_fixture() do
    <<12, 104, 113, 58, 16, 120, 235, 132, 112, 134, 139, 233, 218, 113, 105, 86, 88, 92, 178, 25, 148, 200, 35, 40,
      184, 241, 124, 43, 206, 171, 247, 4>>
    |> Binary.new!()
  end

  ## Baked-in signing key.
  def signing_key_fixture() do
    %{
      public:
        <<135, 239, 26, 131, 57, 35, 38, 126, 239, 6, 121, 177, 246, 42, 233, 181, 98, 193, 100, 126, 8, 206, 121, 105,
          146, 12, 220, 59, 116, 84, 7, 188>>,
      secret:
        <<77, 72, 93, 178, 84, 19, 51, 69, 29, 84, 20, 29, 154, 216, 187, 83, 217, 147, 109, 200, 157, 114, 49, 191, 42,
          191, 1, 184, 8, 251, 185, 245, 135, 239, 26, 131, 57, 35, 38, 126, 239, 6, 121, 177, 246, 42, 233, 181, 98,
          193, 100, 126, 8, 206, 121, 105, 146, 12, 220, 59, 116, 84, 7, 188>>
    }
    |> Witchcraft.Functor.map(&Binary.new!/1)
  end

  ## Get nth signing key from the baked-in main key.
  def signing_key_fixture(n) do
    main_key_fixture()
    |> OnTheMap.Crypto.derive_signing_keypair(n)
  end

  def generate_random_identity(url \\ "http://startup.com") do
    %{
      url: url,
      secret: generate_secret()
    }
  end

  ## Generate nth crypto-safe identity.
  # schema "crypto_identities" do
  #   # Urlsafe base64 encoded public key
  #   field :pk, :string
  #   # FQDN of the user's website
  #   field :url, :string
  #   # Current challenge for the identity
  #   field :challenge, :string
  #
  #   timestamps()
  # end
  @spec generate_crypto_identity(integer(), String.t()) :: {map(), String.t()}
  def generate_crypto_identity(n \\ 1, url \\ "http://startup.com") do
    kp = signing_key_fixture(n)

    {
      %{
        url: url,
        pk: (kp.public |> B.safe!()).encoded
      },
      (kp.secret |> B.safe!()).raw
    }
  end

  ## Generate random crypto-safe identity.
  def generate_random_crypto_identity(url \\ "http://startup.com") do
    generate_crypto_identity(:rand.uniform(63), url)
  end

  defp generate_secret do
    Stream.repeatedly(&random_char_from_alphabet/0)
    |> Enum.take(1024)
    |> List.to_string()
  end

  @chars Enum.concat([?0..?9, ?A..?Z, ?a..?z])

  defp random_char_from_alphabet, do: Enum.random(@chars)
end

defmodule PhoenixPair.User do
  use PhoenixPair.Web, :model

  @derive {Poison.Encoder, only: [:id, :first_name, :last_name, :email]}
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email])
    # |> unique_constraint(:email, message: "Email already taken")
    |> generate_encrypted_password
  end 

  defp generate_encrypted_password(current_changeset) do 
    case current_changeset do 
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end

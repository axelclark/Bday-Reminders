defmodule Bdayreminder.Contacts.Birthday do
  use Ecto.Schema
  import Ecto.Changeset

  schema "birthdays" do
    field :name, :string
    field :birthday, :string
    field :phone_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(birthday, attrs) do
    birthday
    |> cast(attrs, [:name, :birthday, :phone_number])
    |> validate_required([:name, :birthday, :phone_number])
  end
end

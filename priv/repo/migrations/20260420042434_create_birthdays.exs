defmodule Bdayreminder.Repo.Migrations.CreateBirthdays do
  use Ecto.Migration

  def change do
    create table(:birthdays) do
      add :name, :string, null: false
      add :birthday, :string, null: false
      add :phone_number, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Bdayreminder.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bdayreminder.Contacts` context.
  """

  @doc """
  Generate a birthday.
  """
  def birthday_fixture(attrs \\ %{}) do
    {:ok, birthday} =
      attrs
      |> Enum.into(%{
        birthday: "some birthday",
        name: "some name",
        phone_number: "some phone_number"
      })
      |> Bdayreminder.Contacts.create_birthday()

    birthday
  end
end

defmodule Bdayreminder.ContactsTest do
  use Bdayreminder.DataCase

  alias Bdayreminder.Contacts

  describe "birthdays" do
    alias Bdayreminder.Contacts.Birthday

    import Bdayreminder.ContactsFixtures

    @invalid_attrs %{name: nil, birthday: nil, phone_number: nil}

    test "list_birthdays/0 returns all birthdays" do
      birthday = birthday_fixture()
      assert Contacts.list_birthdays() == [birthday]
    end

    test "get_birthday!/1 returns the birthday with given id" do
      birthday = birthday_fixture()
      assert Contacts.get_birthday!(birthday.id) == birthday
    end

    test "create_birthday/1 with valid data creates a birthday" do
      valid_attrs = %{
        name: "some name",
        birthday: "some birthday",
        phone_number: "some phone_number"
      }

      assert {:ok, %Birthday{} = birthday} = Contacts.create_birthday(valid_attrs)
      assert birthday.name == "some name"
      assert birthday.birthday == "some birthday"
      assert birthday.phone_number == "some phone_number"
    end

    test "create_birthday/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_birthday(@invalid_attrs)
    end

    test "update_birthday/2 with valid data updates the birthday" do
      birthday = birthday_fixture()

      update_attrs = %{
        name: "some updated name",
        birthday: "some updated birthday",
        phone_number: "some updated phone_number"
      }

      assert {:ok, %Birthday{} = birthday} = Contacts.update_birthday(birthday, update_attrs)
      assert birthday.name == "some updated name"
      assert birthday.birthday == "some updated birthday"
      assert birthday.phone_number == "some updated phone_number"
    end

    test "update_birthday/2 with invalid data returns error changeset" do
      birthday = birthday_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_birthday(birthday, @invalid_attrs)
      assert birthday == Contacts.get_birthday!(birthday.id)
    end

    test "delete_birthday/1 deletes the birthday" do
      birthday = birthday_fixture()
      assert {:ok, %Birthday{}} = Contacts.delete_birthday(birthday)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_birthday!(birthday.id) end
    end

    test "change_birthday/1 returns a birthday changeset" do
      birthday = birthday_fixture()
      assert %Ecto.Changeset{} = Contacts.change_birthday(birthday)
    end
  end
end

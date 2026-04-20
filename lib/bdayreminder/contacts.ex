defmodule Bdayreminder.Contacts do
  @moduledoc """
  The Contacts context.
  """

  import Ecto.Query, warn: false
  alias Bdayreminder.Repo

  alias Bdayreminder.Contacts.Birthday
  alias Phoenix.PubSub

  @topic inspect(__MODULE__) <> ".birthdays"

  def subscribe do
    PubSub.subscribe(Bdayreminder.PubSub, @topic)
  end

  def unsubscribe do
    PubSub.unsubscribe(Bdayreminder.PubSub, @topic)
  end

  @doc """
  Returns the list of birthdays.

  ## Examples

      iex> list_birthdays()
      [%Birthday{}, ...]

  """
  def list_birthdays do
    Repo.all(Birthday)
  end

  @doc """
  Gets a single birthday.

  Raises `Ecto.NoResultsError` if the Birthday does not exist.

  ## Examples

      iex> get_birthday!(123)
      %Birthday{}

      iex> get_birthday!(456)
      ** (Ecto.NoResultsError)

  """
  def get_birthday!(id), do: Repo.get!(Birthday, id)

  @doc """
  Creates a birthday.

  ## Examples

      iex> create_birthday(%{field: value})
      {:ok, %Birthday{}}

      iex> create_birthday(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_birthday(attrs) do
    %Birthday{}
    |> Birthday.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:birthday, :created])
  end

  @doc """
  Updates a birthday.

  ## Examples

      iex> update_birthday(birthday, %{field: new_value})
      {:ok, %Birthday{}}

      iex> update_birthday(birthday, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_birthday(%Birthday{} = birthday, attrs) do
    birthday
    |> Birthday.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:birthday, :updated])
  end

  @doc """
  Deletes a birthday.

  ## Examples

      iex> delete_birthday(birthday)
      {:ok, %Birthday{}}

      iex> delete_birthday(birthday)
      {:error, %Ecto.Changeset{}}

  """
  def delete_birthday(%Birthday{} = birthday) do
    Repo.delete(birthday)
    |> notify_subscribers([:birthday, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking birthday changes.

  ## Examples

      iex> change_birthday(birthday)
      %Ecto.Changeset{data: %Birthday{}}

  """
  def change_birthday(%Birthday{} = birthday, attrs \\ %{}) do
    Birthday.changeset(birthday, attrs)
  end

  defp notify_subscribers({:ok, birthday} = result, event) do
    PubSub.broadcast(Bdayreminder.PubSub, @topic, {event, birthday})
    result
  end

  defp notify_subscribers(result, _event), do: result
end

defmodule BdayreminderWeb.BirthdayLive.Index do
  use BdayreminderWeb, :live_view

  alias Bdayreminder.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Birthdays
        <:actions>
          <.button variant="primary" navigate={~p"/birthdays/new"}>
            <.icon name="hero-plus" /> New Birthday
          </.button>
        </:actions>
      </.header>

      <.table
        id="birthdays"
        rows={@streams.birthdays}
        row_click={fn {_id, birthday} -> JS.navigate(~p"/birthdays/#{birthday}") end}
      >
        <:col :let={{_id, birthday}} label="Name">{birthday.name}</:col>
        <:col :let={{_id, birthday}} label="Birthday">{birthday.birthday}</:col>
        <:col :let={{_id, birthday}} label="Phone number">{birthday.phone_number}</:col>
        <:action :let={{_id, birthday}}>
          <div class="sr-only">
            <.link navigate={~p"/birthdays/#{birthday}"}>Show</.link>
          </div>
          <.link navigate={~p"/birthdays/#{birthday}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, birthday}}>
          <.link
            phx-click={JS.push("delete", value: %{id: birthday.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Birthdays")
     |> stream(:birthdays, list_birthdays())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    birthday = Contacts.get_birthday!(id)
    {:ok, _} = Contacts.delete_birthday(birthday)

    {:noreply, stream_delete(socket, :birthdays, birthday)}
  end

  defp list_birthdays() do
    Contacts.list_birthdays()
  end
end

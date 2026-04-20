defmodule BdayreminderWeb.BirthdayLive.Show do
  use BdayreminderWeb, :live_view

  alias Bdayreminder.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@birthday.name}
        <:subtitle>Birthday contact details.</:subtitle>
        <:actions>
          <.button navigate={~p"/birthdays"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/birthdays/#{@birthday}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit birthday
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@birthday.name}</:item>
        <:item title="Birthday">{@birthday.birthday}</:item>
        <:item title="Phone number">{@birthday.phone_number}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Birthday")
     |> assign(:birthday, Contacts.get_birthday!(id))}
  end
end

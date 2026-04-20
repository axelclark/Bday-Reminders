defmodule BdayreminderWeb.BirthdayLive.Form do
  use BdayreminderWeb, :live_view

  alias Bdayreminder.Contacts
  alias Bdayreminder.Contacts.Birthday

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage birthday records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="birthday-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:birthday]} type="text" label="Birthday" />
        <.input field={@form[:phone_number]} type="text" label="Phone number" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Birthday</.button>
          <.button navigate={return_path(@return_to, @birthday)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    birthday = Contacts.get_birthday!(id)

    socket
    |> assign(:page_title, "Edit Birthday")
    |> assign(:birthday, birthday)
    |> assign(:form, to_form(Contacts.change_birthday(birthday)))
  end

  defp apply_action(socket, :new, _params) do
    birthday = %Birthday{}

    socket
    |> assign(:page_title, "New Birthday")
    |> assign(:birthday, birthday)
    |> assign(:form, to_form(Contacts.change_birthday(birthday)))
  end

  @impl true
  def handle_event("validate", %{"birthday" => birthday_params}, socket) do
    changeset = Contacts.change_birthday(socket.assigns.birthday, birthday_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"birthday" => birthday_params}, socket) do
    save_birthday(socket, socket.assigns.live_action, birthday_params)
  end

  defp save_birthday(socket, :edit, birthday_params) do
    case Contacts.update_birthday(socket.assigns.birthday, birthday_params) do
      {:ok, birthday} ->
        {:noreply,
         socket
         |> put_flash(:info, "Birthday updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, birthday))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_birthday(socket, :new, birthday_params) do
    case Contacts.create_birthday(birthday_params) do
      {:ok, birthday} ->
        {:noreply,
         socket
         |> put_flash(:info, "Birthday created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, birthday))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _birthday), do: ~p"/birthdays"
  defp return_path("show", birthday), do: ~p"/birthdays/#{birthday}"
end

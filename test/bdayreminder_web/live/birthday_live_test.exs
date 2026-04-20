defmodule BdayreminderWeb.BirthdayLiveTest do
  use BdayreminderWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bdayreminder.ContactsFixtures

  @create_attrs %{name: "some name", birthday: "some birthday", phone_number: "some phone_number"}
  @update_attrs %{
    name: "some updated name",
    birthday: "some updated birthday",
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{name: nil, birthday: nil, phone_number: nil}
  defp create_birthday(_) do
    birthday = birthday_fixture()

    %{birthday: birthday}
  end

  describe "Index" do
    setup [:create_birthday]

    test "lists all birthdays", %{conn: conn, birthday: birthday} do
      {:ok, _index_live, html} = live(conn, ~p"/birthdays")

      assert html =~ "Listing Birthdays"
      assert html =~ birthday.name
    end

    test "saves new birthday", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/birthdays")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Birthday")
               |> render_click()
               |> follow_redirect(conn, ~p"/birthdays/new")

      assert render(form_live) =~ "New Birthday"

      assert form_live
             |> form("#birthday-form", birthday: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#birthday-form", birthday: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/birthdays")

      html = render(index_live)
      assert html =~ "Birthday created successfully"
      assert html =~ "some name"
    end

    test "updates birthday in listing", %{conn: conn, birthday: birthday} do
      {:ok, index_live, _html} = live(conn, ~p"/birthdays")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#birthdays-#{birthday.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/birthdays/#{birthday}/edit")

      assert render(form_live) =~ "Edit Birthday"

      assert form_live
             |> form("#birthday-form", birthday: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#birthday-form", birthday: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/birthdays")

      html = render(index_live)
      assert html =~ "Birthday updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes birthday in listing", %{conn: conn, birthday: birthday} do
      {:ok, index_live, _html} = live(conn, ~p"/birthdays")

      assert index_live |> element("#birthdays-#{birthday.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#birthdays-#{birthday.id}")
    end
  end

  describe "Show" do
    setup [:create_birthday]

    test "displays birthday", %{conn: conn, birthday: birthday} do
      {:ok, _show_live, html} = live(conn, ~p"/birthdays/#{birthday}")

      assert html =~ "Show Birthday"
      assert html =~ birthday.name
    end

    test "updates birthday and returns to show", %{conn: conn, birthday: birthday} do
      {:ok, show_live, _html} = live(conn, ~p"/birthdays/#{birthday}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/birthdays/#{birthday}/edit?return_to=show")

      assert render(form_live) =~ "Edit Birthday"

      assert form_live
             |> form("#birthday-form", birthday: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#birthday-form", birthday: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/birthdays/#{birthday}")

      html = render(show_live)
      assert html =~ "Birthday updated successfully"
      assert html =~ "some updated name"
    end
  end
end

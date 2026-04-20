defmodule BdayreminderWeb.PageController do
  use BdayreminderWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

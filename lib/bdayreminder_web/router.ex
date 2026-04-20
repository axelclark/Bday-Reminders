defmodule BdayreminderWeb.Router do
  use BdayreminderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BdayreminderWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BdayreminderWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/birthdays", BirthdayLive.Index, :index
    live "/birthdays/new", BirthdayLive.Form, :new
    live "/birthdays/:id", BirthdayLive.Show, :show
    live "/birthdays/:id/edit", BirthdayLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", BdayreminderWeb do
  #   pipe_through :api
  # end
end

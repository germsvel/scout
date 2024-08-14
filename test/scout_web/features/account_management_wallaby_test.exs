defmodule ScoutWeb.AccountManagementWallabyTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Scout.AccountsFixtures

  import Wallaby.Query

  @create_attrs %{name: "some name", age: 42, active_at: "2024-02-16 15:08:00"}
  # @update_attrs %{name: "some updated name", age: 43, active_at: "2024-02-17 15:08:00"}
  # @invalid_attrs %{name: nil, age: nil, active_at: nil}

  feature "list all users", %{session: session} do
    user = create_user()

    session
    |> visit("/users")
    |> assert_has(css("h1", text: "Listing Users"))
    |> assert_has(css("#users", text: user.name))
  end

  feature "create users", %{session: session} do
    session
    |> visit("/users")
    |> click(link("New User"))
    |> fill_in(text_field("Name"), with: @create_attrs.name)
    |> fill_in(text_field("Age"), with: @create_attrs.age)
    |> fill_in(text_field("Active at"), with: @create_attrs.active_at)
    |> click(button("Save User"))
    |> take_screenshot()
    |> assert_has(css("#flash-group", text: "User created successfully"))
    |> assert_has(css("div", text: @create_attrs.name))
  end
end

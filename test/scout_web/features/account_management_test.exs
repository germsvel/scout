defmodule ScoutWeb.AccountManagementTest do
  use ScoutWeb.FeatureCase, async: true

  import Scout.AccountsFixtures

  @create_attrs %{name: "some name", age: 42, active_at: "2024-02-16 15:08:00"}
  @update_attrs %{name: "some updated name", age: 43, active_at: "2024-02-17 15:08:00"}
  @invalid_attrs %{name: nil, age: nil, active_at: nil}

  test "lists all users", %{conn: conn} do
    conn
    |> visit(~p"/users")
    |> assert_has("h1", "Listing Users")
  end

  describe "create user" do
    test "can create new user", %{conn: conn} do
      conn
      |> visit(~p"/users")
      |> click_link("New User")
      |> fill_form("form", user: @create_attrs)
      |> click_button("Save User")
      |> assert_has("#flash-group", "User created successfully")
      |> assert_has("div", @create_attrs.name)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn
      |> visit(~p"/users")
      |> click_link("New User")
      |> fill_form("form", user: @invalid_attrs)
      |> click_button("Save User")
      |> assert_has("form", "can't be blank")
    end
  end

  describe "edit and update user" do
    test "can update a user", %{conn: conn} do
      user = create_user()

      conn
      |> visit(~p"/users/#{user}")
      |> click_link("Edit user")
      |> fill_form("form", user: @update_attrs)
      |> click_button("Save User")
      |> assert_has("#flash-group", "User updated successfully")
      |> assert_has("div", @update_attrs.name)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = create_user()

      conn
      |> visit(~p"/users/#{user}")
      |> click_link("Edit user")
      |> fill_form("form", user: @invalid_attrs)
      |> click_button("Save User")
      |> assert_has("form", "can't be blank")
    end
  end

  test "can delete user", %{conn: conn} do
    user = create_user()

    conn
    |> visit(~p"/users")
    |> click_link("Delete")
    |> assert_has("#flash-group", "User deleted successfully")
    |> refute_has("div", user.name)
  end
end

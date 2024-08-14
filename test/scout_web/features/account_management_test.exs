defmodule ScoutWeb.AccountManagementTest do
  use ScoutWeb.FeatureCase, async: true

  import Scout.AccountsFixtures

  @create_attrs %{name: "some name", age: 42, active_at: "2024-02-16 15:08:00"}
  @update_attrs %{name: "some updated name", age: 43, active_at: "2024-02-17 15:08:00"}
  @invalid_attrs %{name: nil, age: nil, active_at: nil}

  test "lists all users", %{conn: conn} do
    user = create_user()

    conn
    |> visit(~p"/users")
    |> assert_has("h1", text: "Listing Users")
    |> assert_has("#users", text: user.name)
  end

  describe "create user" do
    test "can create new user", %{conn: conn} do
      conn
      |> visit(~p"/users")
      |> click_link("New User")
      |> fill_in("Name", with: @create_attrs.name)
      |> fill_in("Age", with: @create_attrs.age)
      |> fill_in("Active at", with: @create_attrs.active_at)
      |> click_button("Save User")
      |> assert_has("#flash-group", text: "User created successfully")
      |> assert_has("div", text: @create_attrs.name)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn
      |> visit(~p"/users")
      |> click_link("New User")
      |> fill_in("Name", with: @invalid_attrs.name)
      |> fill_in("Age", with: @invalid_attrs.age)
      |> fill_in("Active at", with: @invalid_attrs.active_at)
      |> click_button("Save User")
      |> assert_has("form", text: "can't be blank")
    end
  end

  describe "edit and update user" do
    test "can update a user", %{conn: conn} do
      user = create_user()

      conn
      |> visit(~p"/users/#{user}")
      |> click_link("Edit user")
      |> fill_in("Name", with: @update_attrs.name)
      |> fill_in("Age", with: @update_attrs.age)
      |> fill_in("Active at", with: @update_attrs.active_at)
      |> click_button("Save User")
      |> assert_has("#flash-group", text: "User updated successfully")
      |> assert_has("div", text: @update_attrs.name)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = create_user()

      conn
      |> visit(~p"/users/#{user}")
      |> click_link("Edit user")
      |> fill_in("Name", with: @invalid_attrs.name)
      |> fill_in("Age", with: @invalid_attrs.age)
      |> fill_in("Active at", with: @invalid_attrs.active_at)
      |> click_button("Save User")
      |> assert_has("form", text: "can't be blank")
    end
  end

  test "can delete user", %{conn: conn} do
    user = create_user()

    conn
    |> visit(~p"/users")
    |> click_link("Delete")
    |> assert_has("#flash-group", text: "User deleted successfully")
    |> refute_has("div", text: user.name)
  end
end

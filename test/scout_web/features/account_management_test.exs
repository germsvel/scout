defmodule ScoutWeb.AccountManagementTest do
  use ScoutWeb.FeatureCase, async: true

  import Scout.AccountsFixtures

  describe "create user" do
    test "can create new user", %{conn: conn} do
      create_attrs = %{name: "some name", age: 42, active_at: "2024-02-16 15:08:00"}

      conn
      |> visit(~p"/users")
      |> click_link("New User")
      |> fill_in("Name", with: create_attrs.name)
      |> fill_in("Age", with: create_attrs.age)
      |> fill_in("Active at", with: create_attrs.active_at)
      |> click_button("Save User")
      |> assert_has("#flash-group", text: "User created successfully")
      |> assert_has("#users", text: create_attrs.name)
    end

    for i <- 1..100 do
      test "can create new user #{i}", %{conn: conn} do
        create_attrs = %{name: "some name", age: 42, active_at: "2024-02-16 15:08:00"}

        conn
        |> visit(~p"/users")
        |> click_link("New User")
        |> fill_in("Name", with: create_attrs.name)
        |> fill_in("Age", with: create_attrs.age)
        |> fill_in("Active at", with: create_attrs.active_at)
        |> click_button("Save User")
        |> assert_has("#flash-group", text: "User created successfully")
        |> assert_has("#users", text: create_attrs.name)
      end
    end
  end

  test "can delete user", %{conn: conn} do
    user = create_user()

    conn
    |> visit(~p"/users")
    |> click_link("Delete")
    |> assert_has("#flash-group", text: "User deleted successfully")
    |> refute_has("#users", text: user.name)
  end
end

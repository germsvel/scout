defmodule ScoutWeb.UserControllerTest do
  use ScoutWeb.ConnCase

  describe "Pain points 😰" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/users")

      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      create_attrs = %{name: "some name", age: 42, active_at: ~N[2024-02-16 15:08:00]}
      conn = post(conn, ~p"/users", user: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/users/#{id}"

      conn = get(conn, ~p"/users/#{id}")
      assert html_response(conn, 200) =~ "User #{id}"
    end
  end
end

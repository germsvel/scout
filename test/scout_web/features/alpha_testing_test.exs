defmodule ScoutWeb.AlphaTestingTest do
  use ScoutWeb.FeatureCase, async: true

  test "works with uploads", %{conn: conn} do
    conn
    |> visit(~p"/alpha")
    |> fill_in("Greeting", with: "Hello world!")
    |> upload("Avatar", "./test/support/files/elixir.jpg")
    |> submit()
    |> assert_has("[data-role=upload]", text: "/uploads/live_view_upload")
  end
end

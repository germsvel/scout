defmodule ScoutWeb.TimelinePostsTest do
  use ScoutWeb.FeatureCase, async: true

  describe "No pain! 🤩" do
    test "user can save new post", %{conn: conn} do
      create_attrs = %{body: "some body", published_date: "2024-02-17"}

      conn
      |> visit(~p"/posts")
      |> click_link("New Post")
      |> fill_in("Body", with: create_attrs.body)
      |> fill_in("Published date", with: create_attrs.published_date)
      |> check("Draft")
      |> click_button("Save Post")
      |> assert_has("#flash-info", text: "Post created successfully")
      |> assert_has("#posts", text: create_attrs.body)
    end

    test "user can see their posts (LiveView -> dead view)", %{conn: conn} do
      conn
      |> visit(~p"/posts")
      |> click_link("Users")
      |> assert_has("h1", text: "Listing Users")
    end

    for i <- 1..100 do
      test "user can save new post #{i}", %{conn: conn} do
        create_attrs = %{body: "some body", published_date: "2024-02-17"}

        conn
        |> visit(~p"/posts")
        |> click_link("New Post")
        |> fill_in("Body", with: create_attrs.body)
        |> fill_in("Published date", with: create_attrs.published_date)
        |> check("Draft")
        |> click_button("Save Post")
        |> assert_has("#flash-info", text: "Post created successfully")
        |> assert_has("#posts", text: create_attrs.body)
      end
    end
  end
end

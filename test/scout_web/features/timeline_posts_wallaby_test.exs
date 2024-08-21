defmodule ScoutWeb.TimelinePostsWallabyTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  feature "user can create new posts users", %{session: session} do
    create_attrs = %{body: "some body", published_date: "02-17-2024"}

    session
    |> visit("/posts")
    |> click(link("New Post"))
    |> fill_in(text_field("Body"), with: create_attrs.body)
    |> fill_in(text_field("Published date"), with: create_attrs.published_date)
    |> click(checkbox("Draft"))
    |> click(button("Save Post"))
    |> assert_has(css("#flash-group", text: "Post created successfully"))
    |> assert_has(css("#posts", text: create_attrs.body))
  end

  for i <- 1..100 do
    test "user can create new posts users #{i}", %{session: session} do
      create_attrs = %{body: "some body", published_date: "02-17-2024"}

      session
      |> visit("/posts")
      |> click(link("New Post"))
      |> fill_in(text_field("Body"), with: create_attrs.body)
      |> fill_in(text_field("Published date"), with: create_attrs.published_date)
      |> click(checkbox("Draft"))
      |> click(button("Save Post"))
      |> assert_has(css("#flash-group", text: "Post created successfully"))
      |> assert_has(css("#posts", text: create_attrs.body))
    end
  end
end

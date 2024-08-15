defmodule ScoutWeb.TimelinePostsWallabyTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Scout.TimelineFixtures

  import Wallaby.Query

  @create_attrs %{body: "some body", draft: true, published_date: "02-17-2024"}

  feature "user can see all posts", %{session: session} do
    post1 = create_post(body: "Post 1")
    post2 = create_post(body: "Post 2")

    session
    |> visit("/posts")
    |> assert_has(css("h1", text: "Listing Posts"))
    |> assert_has(css("#posts-#{post1.id}", text: post1.body))
    |> assert_has(css("#posts-#{post2.id}", text: post2.body))
  end

  feature "user can create new posts users", %{session: session} do
    session
    |> visit("/posts")
    |> click(link("New Post"))
    |> fill_in(text_field("Body"), with: @create_attrs.body)
    |> fill_in(text_field("Published date"), with: @create_attrs.published_date)
    |> click(checkbox("Draft"))
    |> click(button("Save Post"))
    |> assert_has(css("#flash-group", text: "Post created successfully"))
    |> assert_has(css("#posts", text: @create_attrs.body))
  end

  for i <- 1..100 do
    test "user can create new posts users #{i}", %{session: session} do
      session
      |> visit("/posts")
      |> click(link("New Post"))
      |> fill_in(text_field("Body"), with: @create_attrs.body)
      |> fill_in(text_field("Published date"), with: @create_attrs.published_date)
      |> click(checkbox("Draft"))
      |> click(button("Save Post"))
      |> assert_has(css("#flash-group", text: "Post created successfully"))
      |> assert_has(css("#posts", text: @create_attrs.body))
    end
  end
end

defmodule ScoutWeb.TimelinePostsTest do
  use ScoutWeb.FeatureCase, async: true

  import Scout.TimelineFixtures

  describe "Index" do
    test "posts page shows all posts", %{conn: conn} do
      post1 = create_post(body: "Post 1")
      post2 = create_post(body: "Post 2")

      conn
      |> visit(~p"/posts")
      |> assert_has("h1", text: "Listing Posts")
      |> assert_has("#posts-#{post1.id}", text: post1.body)
      |> assert_has("#posts-#{post2.id}", text: post2.body)
    end

    test "user can navigate to their own posts", %{conn: conn} do
      conn
      |> visit(~p"/posts")
      |> click_link("Users")
      |> assert_has("h1", text: "Users")
    end

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

    test "user can update a post", %{conn: conn} do
      create_post(body: "Some post")

      conn
      |> visit(~p"/posts")
      |> click_link("Edit")
      |> fill_in("Body", with: "Some other post")
      |> click_button("Save Post")
      |> assert_has("#flash-info", text: "Post updated successfully")
      |> assert_has("#posts", text: "Some other post")
    end

    test "shows error when updating a post with invalid args", %{conn: conn} do
      create_post(body: "Some post")

      conn
      |> visit(~p"/posts")
      |> click_link("Edit")
      |> fill_in("Body", with: nil)
      |> fill_in("Published date", with: nil)
      |> assert_has("#post-form", text: "can't be blank")
    end
  end

  describe "Show" do
    test "displays post", %{conn: conn} do
      post = create_post()

      conn
      |> visit(~p"/posts/#{post}")
      |> assert_has("h1", text: "Post #{post.id}")
      |> assert_has("div", text: post.body)
    end

    test "updates post within modal", %{conn: conn} do
      post = create_post(body: "Some post")

      conn
      |> visit(~p"/posts/#{post}")
      |> click_link("Edit")
      |> fill_in("Body", with: "Some other post")
      |> click_button("Save Post")
      |> assert_has("#flash-info", text: "Post updated successfully")
      |> assert_has("div", text: "Some other post")
    end

    test "shows errors when updating with invalid arguments", %{conn: conn} do
      post = create_post()

      conn
      |> visit(~p"/posts/#{post}")
      |> click_link("Edit")
      |> fill_in("Body", with: nil)
      |> fill_in("Published date", with: nil)
      |> assert_has("#post-form", text: "can't be blank")
    end
  end
end

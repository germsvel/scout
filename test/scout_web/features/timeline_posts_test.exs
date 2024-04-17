defmodule ScoutWeb.TimelinePostsTest do
  use ScoutWeb.FeatureCase, async: true

  import Scout.TimelineFixtures

  @create_attrs %{body: "some body", draft: true, published_date: "2024-02-17"}
  @update_attrs %{body: "some updated body", draft: false, published_date: "2024-02-18"}
  @invalid_attrs %{body: nil, draft: false, published_date: nil}

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

    test "user can save new post", %{conn: conn} do
      session =
        conn
        |> visit(~p"/posts")
        |> click_link("New Post")
        |> fill_in("Body", with: @invalid_attrs.body)
        |> fill_in("Published date", with: @invalid_attrs.published_date)
        |> assert_has("#post-form", text: "can't be blank")

      session
      |> fill_in("Body", with: @create_attrs.body)
      |> fill_in("Published date", with: @create_attrs.published_date)
      |> check("Draft")
      |> click_button("Save Post")
      |> assert_has("#flash-group", text: "Post created successfully")
      |> assert_has("#posts", text: @create_attrs.body)
    end

    test "user can update a post", %{conn: conn} do
      create_post(body: "Some post")

      session =
        conn
        |> visit(~p"/posts")
        |> click_link("Edit")
        |> fill_in("Body", with: @invalid_attrs.body)
        |> fill_in("Published date", with: @invalid_attrs.published_date)
        |> assert_has("#post-form", text: "can't be blank")

      session
      |> fill_in("Body", with: @update_attrs.body)
      |> fill_in("Published date", with: @update_attrs.published_date)
      |> click_button("Save Post")
      |> assert_has("#flash-group", text: "Post updated successfully")
      |> assert_has("#posts", text: @update_attrs.body)
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
      post = create_post()

      session =
        conn
        |> visit(~p"/posts/#{post}")
        |> click_link("Edit")
        |> fill_in("Body", with: @invalid_attrs.body)
        |> fill_in("Published date", with: @invalid_attrs.published_date)
        |> assert_has("#post-form", text: "can't be blank")

      session
      |> fill_in("Body", with: @update_attrs.body)
      |> fill_in("Published date", with: @update_attrs.published_date)
      |> click_button("Save Post")
      |> assert_has("#flash-group", text: "Post updated successfully")
      |> assert_has("div", text: @update_attrs.body)
    end
  end
end

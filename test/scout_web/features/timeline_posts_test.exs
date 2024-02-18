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
      |> assert_has("h1", "Listing Posts")
      |> assert_has("#posts-#{post1.id}", post1.body)
      |> assert_has("#posts-#{post2.id}", post2.body)
    end

    test "user can save new post", %{conn: conn} do
      session =
        conn
        |> visit(~p"/posts")
        |> click_button("a", "New Post")
        |> fill_form("#post-form", post: @invalid_attrs)
        |> assert_has("#post-form", "can't be blank")

      session
      |> fill_form("#post-form", post: @create_attrs)
      |> click_button("Save Post")
      |> assert_has("#flash-group", "Post created successfully")
      |> assert_has("#posts", @create_attrs.body)
    end

    test "user can update a post", %{conn: conn} do
      post = create_post(body: "Some post")

      session =
        conn
        |> visit(~p"/posts")
        |> click_link("#posts-#{post.id} a", "Edit")
        |> fill_form("#post-form", post: @invalid_attrs)
        |> assert_has("#post-form", "can't be blank")

      session
      |> fill_form("#post-form", post: @update_attrs)
      |> click_button("Save Post")
      |> assert_has("#flash-group", "Post updated successfully")
      |> assert_has("#posts", @update_attrs.body)
    end
  end

  describe "Show" do
    test "displays post", %{conn: conn} do
      post = create_post()

      conn
      |> visit(~p"/posts/#{post}")
      |> assert_has("h1", "Post #{post.id}")
      |> assert_has("div", post.body)
    end

    test "updates post within modal", %{conn: conn} do
      post = create_post()

      session =
        conn
        |> visit(~p"/posts/#{post}")
        |> click_link("Edit")
        |> fill_form("#post-form", post: @invalid_attrs)
        |> assert_has("#post-form", "can't be blank")

      session
      |> fill_form("#post-form", post: @update_attrs)
      |> click_button("Save Post")
      |> assert_has("#flash-group", "Post updated successfully")
      |> assert_has("div", @update_attrs.body)
    end
  end
end

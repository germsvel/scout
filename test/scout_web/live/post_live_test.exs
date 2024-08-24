defmodule ScoutWeb.PostLiveTest do
  use ScoutWeb.ConnCase

  import Phoenix.LiveViewTest
  import Scout.TimelineFixtures, only: [post_fixture: 0]

  @create_attrs %{body: "some body", draft: true, published_date: "2024-02-17"}
  @update_attrs %{body: "some updated body", draft: false, published_date: "2024-02-18"}
  @invalid_attrs %{body: nil, draft: false, published_date: nil}

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end

  describe "Index" do
    setup [:create_post]

    test "user can navigate to their own posts", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      {:ok, conn} =
        view
        |> element("a", "Users")
        |> render_click()
        |> follow_redirect(conn)

      html = html_response(conn, 200)
      assert html =~ "Users"
    end

    test "lists all posts", %{conn: conn, post: post} do
      {:ok, _view, html} = live(conn, ~p"/posts")

      assert html =~ "Listing Posts"
      assert html =~ post.body
    end

    test "user can create new post", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      view
      |> form("#post-form",
        post: %{
          body: "some body",
          draft: true,
          published_date: "2024-02-17"
        }
      )
      |> render_submit()

      html = render(view)
      assert html =~ "Post created successfully"
      assert html =~ "some body"
    end

    test "saves new post", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view |> element("a", "New Post") |> render_click() =~
               "New Post"

      assert_patch(view, ~p"/posts/new")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#post-form", post: @create_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts")

      html = render(view)
      assert html =~ "Post created successfully"
      assert html =~ "some body"
    end

    test "saves new post with has_element?", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view |> element("a", "New Post") |> render_click() =~
               "New Post"

      assert_patch(view, ~p"/posts/new")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#post-form", post: @create_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts")

      assert has_element?(view, "[role=alert]", "Post created successfully")
    end

    test "updates post in listing", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view |> element("#posts-#{post.id} a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(view, ~p"/posts/#{post}/edit")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#post-form", post: @update_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts")

      html = render(view)
      assert html =~ "Post updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes post in listing", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view |> element("#posts-#{post.id} a", "Delete") |> render_click()
      refute has_element?(view, "#posts-#{post.id}")
    end
  end

  describe "Show" do
    setup [:create_post]

    test "displays post", %{conn: conn, post: post} do
      {:ok, _view, html} = live(conn, ~p"/posts/#{post}")

      assert html =~ "Show Post"
      assert html =~ post.body
    end

    test "updates post within modal", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts/#{post}")

      assert view |> element("a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(view, ~p"/posts/#{post}/show/edit")

      assert view
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#post-form", post: @update_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts/#{post}")

      html = render(view)
      assert html =~ "Post updated successfully"
      assert html =~ "some updated body"
    end
  end
end

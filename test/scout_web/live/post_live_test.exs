defmodule ScoutWeb.PostLiveTest do
  use ScoutWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Pain points 🤕" do
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

    test "saves new post with has_element?", %{conn: conn} do
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

      assert has_element?(view, "[role=alert]", "Post created successfully")
      assert has_element?(view, "#posts", "some body")
    end

    test "user can save post (simple flow)", %{conn: conn} do
      create_attrs = %{body: "some body", draft: true, published_date: "2024-02-17"}
      invalid_attrs = %{body: nil, draft: false, published_date: nil}
      {:ok, view, _html} = live(conn, ~p"/posts")

      assert view |> element("a", "New Post") |> render_click() =~
               "New Post"

      assert_patch(view, ~p"/posts/new")

      assert view
             |> form("#post-form", post: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#post-form", post: create_attrs)
             |> render_submit()

      assert_patch(view, ~p"/posts")

      html = render(view)
      assert html =~ "Post created successfully"
      assert html =~ "some body"
    end

    test "user can navigate to their own posts (LiveView -> dead view)", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts")

      {:ok, conn} =
        view
        |> element("a", "Users")
        |> render_click()
        |> follow_redirect(conn)

      html = html_response(conn, 200)
      assert html =~ "Listing Users"
    end
  end
end

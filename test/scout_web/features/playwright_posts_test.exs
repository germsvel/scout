defmodule ScoutWeb.PlaywrightPostsTests do
  # TODO: We had to set async: false
  use ScoutWeb.ConnCase, async: false
  use PlaywrightTest.Case, async: false

  import Scout.TimelineFixtures

  alias Playwright.Page

  describe "Index" do
    test "posts page shows all posts", %{page: page} do
      post1 = create_post(body: "Post 1")
      post2 = create_post(body: "Post 2")

      url = ScoutWeb.Endpoint.url() <> "/posts"

      page |> Page.goto(url)

      Page.screenshot(page)

      assert Page.text_content(page, "h1") =~ "Listing Posts"
      assert Page.text_content(page, "#posts-#{post1.id}") =~ post1.body
      assert Page.text_content(page, "#posts-#{post2.id}") =~ post2.body
    end

    @create_attrs %{body: "some body", draft: true, published_date: "2024-02-17"}

    test "user can save new post", %{page: page} do
      url = ScoutWeb.Endpoint.url() <> "/posts"

      page |> Page.goto(url)

      Page.click(page, "a", %{text: "New Post"})

      # |> click_link("New Post")
      # |> fill_in("Body", with: @invalid_attrs.body)
      # |> fill_in("Published date", with: @invalid_attrs.published_date)
      # |> assert_has("#post-form", text: "can't be blank")
    end
  end
end

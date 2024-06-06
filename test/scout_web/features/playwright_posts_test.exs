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
  end
end

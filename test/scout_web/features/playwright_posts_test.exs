defmodule ScoutWeb.PlaywrightPostsTests do
  use ScoutWeb.ConnCase, async: true
  use PlaywrightTest.Case, async: true

  import Scout.TimelineFixtures

  alias Playwright.Page

  describe "Index" do
    test "posts page shows all posts", %{page: page} do
      post1 = create_post(body: "Post 1")
      post2 = create_post(body: "Post 2")

      page |> Page.goto("/posts")

      Page.screenshot(page)

      assert Page.text_content(page, "h1") =~ "Listing Posts"
    end
  end
end

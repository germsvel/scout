defmodule ScoutWeb.PlaywrightPostsTests do
  # TODO: We had to set async: false
  use ScoutWeb.ConnCase, async: false
  use PlaywrightTest.Case, async: false

  import Scout.TimelineFixtures

  alias Playwright.Page
  alias Playwright.Locator

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

    test "user can save new post", %{page: page} do
      url = ScoutWeb.Endpoint.url() <> "/posts"

      page |> Page.goto(url)

      Page.click(page, "#new-post-button", %{text: "New Post"})

      :ok =
        page
        |> Page.locator("#post-form [name='post[body]']")
        |> Locator.fill("something")

      :ok =
        page
        |> Page.locator("#post-form [name='post[published_date]']")
        |> Locator.fill("2024-02-17")

      Page.click(page, "#save-post-button", %{text: "Save Post"})

      # how do we wait?
      Process.sleep(1000)

      assert Page.text_content(page, "#posts") =~ "something"
      assert Page.text_content(page, "[role=alert]") =~ "Post created successfully"
    end
  end
end

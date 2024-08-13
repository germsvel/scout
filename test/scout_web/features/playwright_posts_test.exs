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

      # NOTE: this is a legacy text locator
      # https://playwright.dev/python/docs/other-locators#legacy-text-locator
      # But playwright-elixir doesn't support the new get_by_text yet
      #
      # We can also chain selectors (also doing it in deprecated way)
      # https://playwright.dev/python/docs/other-locators#chaining-selectors
      :ok =
        Page.click(page, "button >> text='New Post'")

      :ok =
        page
        |> Page.locator("#post-form [name='post[body]']")
        |> Locator.fill("something")

      :ok =
        page
        |> Page.locator("#post-form [name='post[published_date]']")
        |> Locator.fill("2024-02-17")

      Page.click(page, "button >> text='Save Post'")

      assert :ok =
               page
               |> Page.locator("#posts")
               |> Locator.locator("has_text='something'")
               |> Locator.wait_for(%{visible: true})

      assert :ok =
               page
               |> Page.locator("[role=alert]")
               |> Locator.locator("text='Post created successfully'")
               |> Locator.wait_for(%{visible: true})
    end

    test "user can update a post", %{page: page} do
      create_post(body: "Some post")

      url = ScoutWeb.Endpoint.url() <> "/posts"

      page |> Page.goto(url)

      :ok =
        page
        |> Page.locator("a[data-role='edit-post']")
        |> Locator.click()

      :ok =
        page
        |> Page.locator("#post-form [name='post[body]']")
        |> Locator.fill("Some other post")

      Page.click(page, "#save-post-button", %{text: "Save Post"})

      assert :ok =
               page
               |> Page.locator("#posts")
               |> Locator.locator("text='Some other post'")
               |> Locator.wait_for(%{visible: true})

      assert :ok =
               page
               |> Page.locator("[role=alert]")
               |> Locator.locator("text='Post updated successfully'")
               |> Locator.wait_for(%{visible: true})
    end
  end
end

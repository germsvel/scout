defmodule ScoutWeb.UserHTMLTest do
  use ScoutWeb.ConnCase, async: true

  import Phoenix.Template

  describe "index" do
    test "renders User listing" do
      assigns = %{users: []}

      html = render_to_string(ScoutWeb.UserHTML, "index", "html", assigns)

      assert html =~ "Listing Users"
    end
  end
end

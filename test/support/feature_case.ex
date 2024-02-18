defmodule ScoutWeb.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by tests that require setting up
  a connection to test feature tests.

  Such tests rely on `PhoenixTest` and also import other functionality to
  make it easier to build common data structures and interact with pages.

  Finally, if the test case interacts with the database, we enable the SQL
  sandbox, so changes done to the database are reverted at the end of every
  test. If you are using PostgreSQL, you can even run database tests
  asynchronously by setting `use ScoutWeb.FeatureCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use ScoutWeb, :verified_routes

      import ScoutWeb.FeatureCase

      import PhoenixTest
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Scout.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

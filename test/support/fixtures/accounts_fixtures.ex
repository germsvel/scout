defmodule Scout.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scout.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        active_at: ~N[2024-02-16 15:08:00],
        age: 42,
        name: "some name"
      })
      |> Scout.Accounts.create_user()

    user
  end

  def create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        active_at: ~N[2024-02-16 15:08:00],
        age: 42,
        name: "some name"
      })
      |> Scout.Accounts.create_user()

    user
  end
end

defmodule Scout.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scout.Timeline` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        draft: true,
        published_date: ~D[2024-02-17]
      })
      |> Scout.Timeline.create_post()

    post
  end

  def create_post(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        draft: true,
        published_date: ~D[2024-02-17]
      })
      |> Scout.Timeline.create_post()

    post
  end
end

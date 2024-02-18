defmodule Scout.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :draft, :boolean, default: false
    field :published_date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :draft, :published_date])
    |> validate_required([:body, :draft, :published_date])
  end
end

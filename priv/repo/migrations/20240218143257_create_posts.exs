defmodule Scout.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :draft, :boolean, default: false, null: false
      add :published_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end

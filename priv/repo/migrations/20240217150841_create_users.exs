defmodule Scout.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      add :active_at, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end

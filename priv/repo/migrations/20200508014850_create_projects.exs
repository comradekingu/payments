defmodule Payments.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :string, size: 100, primary_key: true

      add :private, :boolean, default: true

      timestamps()
    end
  end
end

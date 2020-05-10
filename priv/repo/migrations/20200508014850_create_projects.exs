defmodule Payments.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :string, size: 255, primary_key: true

      add :private, :boolean, default: true

      timestamps()
    end
  end
end

defmodule Payments.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :amount, :integer, null: false, min: 100

      add :service, :string, null: false
      add :service_id, :string, null: false
      add :resolved, :boolean, default: false

      add :payed_out, :boolean, default: false

      add :user_id, :uuid
      add :project_id, references(:projects, type: :string), null: false

      timestamps(
        updated_at: false,
        primary_key: true
      )
    end

    execute("SELECT create_hypertable('payments', 'inserted_at')")

    create index(:payments, [:user_id, :inserted_at])
    create index(:payments, [:project_id, :resolved, :inserted_at])
  end
end

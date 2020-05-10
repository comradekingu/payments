defmodule Payments.Projects.Project do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  @rdnn_chunk_regex ~r/^[a-zA-Z][a-zA-Z0-9_-]*$/

  schema "projects" do
    field :private, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:id, :private])
    |> validate_required([:id, :private])
    |> validate_rdnn(:id)
  end

  defp validate_rdnn(changeset, field) do
    if valid_rdnn?(get_field(changeset, field, "")) do
      changeset
    else
      add_error(changeset, field, "invalid RDNN")
    end
  end

  def valid_rdnn?(string) when is_binary(string) do
    chunks = String.split(string, ".")

    Enum.all?(chunks, &valid_rdnn_chunk?/1) and
      length(chunks) > 1
  end

  def valid_rdnn?(_), do: false

  defp valid_rdnn_chunk?(string) do
    String.match?(string, @rdnn_chunk_regex)
  end
end

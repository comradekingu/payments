defmodule Payments.Project do
  use Ecto.Schema

  alias Payments.Repo

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

  @doc """
  Validates a given RDNN.

  ## Examples

      iex> valid_rdnn?("io.elementary")
      true

      iex> valid_rdnn?("is this valid")
      false

  """
  def valid_rdnn?(string) when is_binary(string) do
    chunks = String.split(string, ".")

    if length(chunks) > 1 do
      false
    else
      Enum.all?(chunks, &(String.match?(&1, @rdnn_chunk_regex)))
    end
  end

  def valid_rdnn?(_), do: false

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(__MODULE__)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(__MODULE__, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%__MODULE__{} = project, attrs) do
    project
    |> changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%__MODULE__{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%__MODULE__{} = project, attrs \\ %{}) do
    changeset(project, attrs)
  end
end

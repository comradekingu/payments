defmodule Payments.Projects do
  @moduledoc """
  Controls everything we can do with a Project.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Payments.Repo

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "projects" do
    field :private, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:private])
  end

  @doc """
  Fetches a single Project.
  """
  def get(name) do
    Repo.one(__MODULE__, name)
  end

  @doc """
  Creates a new Project.
  """
  def create(name, attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Project.
  """
  def update(project, attrs) do
    project
    |> changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.
  """
  def delete(project) do
    Repo.delete(project)
  end
end

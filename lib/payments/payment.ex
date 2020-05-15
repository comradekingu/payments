defmodule Payments.Payment do
  use Ecto.Schema

  alias Payments.Repo

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "payments" do
    field :amount, :integer

    field :service, :string
    field :service_id, :string
    field :resolved, :boolean, default: false

    field :payed_out, :boolean, default: false

    field :user_id, Ecto.UUID
    belongs_to :project, Project

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:amount, :service, :service_id, :resolved, :payed_out, :user_id, :project_id])
    |> validate_required([:amount, :service, :service_id, :resolved, :payed_out])
    |> validate_number(:amount, greater_than_or_equal_to: 100)
    |> validate_subset(:service, ["stripe"])
    |> assoc_constraint(:project)
  end

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

      iex> Payment |> Query.where(:resolved, true) |> list_payments()
      [%Payment{}, ...]

  """
  def list_payments(query \\ __MODULE__) do
    Repo.all(query)
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!("96b1dad0-9343-4c51-b60a-d154d2cab944")
      %Payment{}

      iex> get_payment!("nope")
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(__MODULE__, id)

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %Project{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%__MODULE__{} = payment, attrs) do
    payment
    |> changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Does any third party service setup logic before setting up payments. This
  should be passed to the client side JS or API layer.

      iex> initiate_payment(project, "stripe", 100)
      {:ok, %{client_secret: "secret_asdfasdf"}}

  """
  def initiate_payment(project, service, amount, user \\ nil)

  def initiate_payment(project, "stripe", amount, user) do
    Stripe.PaymentIntent.create(%{
      amount: amount,
      currency: "USD"
    })
  end

  @doc """
  Processes a payment from a third party service and records it in our database.

  ## Examples

      iex> process_payment(project, %{service: "stripe", token: "card_test"})
      {:ok, payment}

  """
  def process_payment(project, data, user \\ nil)

  def process_payment(project, %{service: "stripe"} = data, user) do
    {:ok, charge} = Stripe.PaymentIntent.create(%{
      amount: data.amount,
      currency: "USD",
      payment_method: data.token
    })
  end
end

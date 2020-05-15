defmodule PaymentsWeb.PaymentLive.New do
  use PaymentsWeb, :live_view

  alias Payments.{Payment, Project}

  @impl true
  def mount(%{"project_id" => project_id}, _session, socket) do
    project = Project.get_project!(project_id)
    {:ok,
      socket
      |> assign(stripe_public_key: stripe_public_key())
      |> assign(project: project)
      |> assign(amount: 100)
      |> assign(payment_data: nil)
    }
  end

  def handle_event("initiate", %{"amount" => amount}, socket) do
    {:ok, data} = Payment.initiate_payment(socket.assigns.project, "stripe", amount)
    {:noreply, assign(socket, payment_data: data)}
  end

  def handle_event("process", data, socket) do
    IO.inspect(data, label: "process data")

    {:noreply, socket}
  end

  defp save_payment(socket, :new, payment_params) do
    case Payment.create_payment(payment_params) do
      {:ok, _payment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Payment created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp stripe_public_key(), do: Application.get_env(:stripity_stripe, :api_key)
end

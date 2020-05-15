defmodule PaymentsWeb.PaymentLive.Show do
  use PaymentsWeb, :live_view

  alias Payments.Payment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Payment")
     |> assign(:payment, Payment.get_payment!(id))}
  end
end

defmodule PaymentsWeb.PaymentLive.Index do
  use PaymentsWeb, :live_view

  require Ecto.Query

  alias Ecto.Query
  alias Payments.Payment
  alias PaymentsWeb.Router.Helpers

  @page_size 50

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:page_title, "Payments")
      |> assign(:page, 1)
      |> assign(:max_page, fetch_max_page())
      |> assign(:payments, fetch_payments())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")

    {:noreply,
      socket
      |> assign(:page, page)
      |> assign(:payments, fetch_payments(page))
    }
  end

  @impl true
  def handle_event("page", page, socket) do
    path = Helpers.live_path(socket, __MODULE__, page: page)
    live_redirect(socket, to: path)
  end

  defp fetch_payments(page \\ 1) do
    offset = (page * @page_size) - @page_size

    Payment
    |> Query.limit(@page_size)
    |> Query.offset(^offset)
    |> Payment.list_payments()
  end

  defp fetch_max_page do
    total = Payments.Repo.aggregate(Payment, :count, :id)
    Float.ceil(total / 10)
  end
end

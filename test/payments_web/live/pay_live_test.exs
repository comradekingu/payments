defmodule PaymentsWeb.PayLiveTest do
  use PaymentsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Payments.Payment

  @create_attrs %{id: "some id"}
  @update_attrs %{id: "some updated id"}
  @invalid_attrs %{id: nil}

  defp fixture(:pay) do
    {:ok, pay} = Payment.create_pay(@create_attrs)
    pay
  end

  defp create_pay(_) do
    pay = fixture(:pay)
    %{pay: pay}
  end

  describe "Index" do
    setup [:create_pay]

    test "lists all payments", %{conn: conn, pay: pay} do
      {:ok, _index_live, html} = live(conn, Routes.pay_index_path(conn, :index))

      assert html =~ "Listing Payments"
      assert html =~ pay.id
    end

    test "saves new pay", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.pay_index_path(conn, :index))

      assert index_live |> element("a", "New Pay") |> render_click() =~
        "New Pay"

      assert_patch(index_live, Routes.pay_index_path(conn, :new))

      assert index_live
             |> form("#pay-form", pay: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pay-form", pay: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pay_index_path(conn, :index))

      assert html =~ "Pay created successfully"
      assert html =~ "some id"
    end

    test "updates pay in listing", %{conn: conn, pay: pay} do
      {:ok, index_live, _html} = live(conn, Routes.pay_index_path(conn, :index))

      assert index_live |> element("#pay-#{pay.id} a", "Edit") |> render_click() =~
        "Edit Pay"

      assert_patch(index_live, Routes.pay_index_path(conn, :edit, pay))

      assert index_live
             |> form("#pay-form", pay: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pay-form", pay: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pay_index_path(conn, :index))

      assert html =~ "Pay updated successfully"
      assert html =~ "some updated id"
    end

    test "deletes pay in listing", %{conn: conn, pay: pay} do
      {:ok, index_live, _html} = live(conn, Routes.pay_index_path(conn, :index))

      assert index_live |> element("#pay-#{pay.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pay-#{pay.id}")
    end
  end

  describe "Show" do
    setup [:create_pay]

    test "displays pay", %{conn: conn, pay: pay} do
      {:ok, _show_live, html} = live(conn, Routes.pay_show_path(conn, :show, pay))

      assert html =~ "Show Pay"
      assert html =~ pay.id
    end

    test "updates pay within modal", %{conn: conn, pay: pay} do
      {:ok, show_live, _html} = live(conn, Routes.pay_show_path(conn, :show, pay))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Pay"

      assert_patch(show_live, Routes.pay_show_path(conn, :edit, pay))

      assert show_live
             |> form("#pay-form", pay: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#pay-form", pay: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pay_show_path(conn, :show, pay))

      assert html =~ "Pay updated successfully"
      assert html =~ "some updated id"
    end
  end
end

defmodule PaymentsWeb.LayoutView do
  use PaymentsWeb, :view

  @doc """
  Returns the current locale
  """
  def lang() do
    Gettext.get_locale(PaymentsWeb.Gettext)
  end

  @doc """
  Gets the current year
  """
  def year() do
    Date.utc_today().year
  end
end

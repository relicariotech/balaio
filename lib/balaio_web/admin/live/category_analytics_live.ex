defmodule BalaioWeb.Admin.CategoryAnalyticsLive do
  use BalaioWeb, :live_component

  alias Balaio.Catalog
  alias Contex.Plot

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_category_filter()
     |> assign_categories_with_quantity_business()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def assign_category_filter(socket) do
    socket
    |> assign(:category_filter, "category_filter")
  end

  def assign_categories_with_quantity_business(
        %{assigns: %{category_filter: category_filter}} = socket
      ) do
    assign(
      socket,
      :categories_with_quantity_business,
      Catalog.categories_with_quantity_business(%{category_filter: category_filter})
    )
  end

  def handle_event("category_filter", %{"category_filter" => category_filter}, socket) do
    {:noreply,
     socket
     |> assign_category_filter()
     |> assign_categories_with_quantity_business()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def assign_dataset(
        %{assigns: %{categories_with_quantity_business: categories_with_quantity_business}} =
          socket
      ) do
    socket
    |> assign(
      :dataset,
      make_bar_chart_dataset(categories_with_quantity_business)
    )
  end

  def make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  def assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  def render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title(), subtitle())
    |> Plot.axis_labels(x_axis(), y_axis())
    |> Plot.to_svg()
  end

  defp title do
    "Categorias"
  end

  defp subtitle do
    "Quantidade de Negócios por Categoria"
  end

  defp x_axis do
    "Categorias"
  end

  defp y_axis do
    "qtd"
  end
end

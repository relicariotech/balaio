defmodule BalaioWeb.BusinessLive.Index do
  use BalaioWeb, :live_view

  alias Balaio.Catalog
  alias Balaio.Catalog.Business

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :business_collection, Catalog.list_business())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Business")
    |> assign(:business, Catalog.get_business!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Business")
    |> assign(:business, %Business{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Business")
    |> assign(:business, nil)
  end

  @impl true
  def handle_info({BalaioWeb.BusinessLive.FormComponent, {:saved, business}}, socket) do
    {:noreply, stream_insert(socket, :business_collection, business)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    business = Catalog.get_business!(id)
    {:ok, _} = Catalog.delete_business(business)

    {:noreply, stream_delete(socket, :business_collection, business)}
  end
end

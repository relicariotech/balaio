defmodule BalaioWeb.BusinessLive.Show do
  use BalaioWeb, :live_view

  alias Balaio.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:business, Catalog.get_business!(id))}
  end

  defp page_title(:show), do: "Show Business"
  defp page_title(:edit), do: "Edit Business"

  def show_sidebar(assigns) do
    ~H"""
    <aside class="mb-8 md:mb-0 md:w-64 lg:w-72 md:ml-12 lg:ml-20 md:shrink-0 md:order-1">
      <div class="sticky top-8">
        <div class="relative bg-gray-50 rounded-xl border border-gray-200 p-5">
          <div class="text-center mb-6">
            <img class="inline-flex mb-2" src={@thumbnail} width="72" height="72" alt={@name} />
            <h2 class="text-lg font-bold text-gray-800"><%= @name %></h2>
          </div>

          <div class="flex justify-center md:justify-start mb-5">
            <ul class="inline-flex flex-col space-y-2">
              <li class="flex items-center">
                <%= if @is_delivery == true do %>
                  <.icon name="hero-truck" class="w-4 h-4 shrink-0 text-gray-400 mr-3" />
                  <span class="text-sm text-gray-600">Delivery</span>
                <% else %>
                <% end %>
              </li>
              <li class="flex items-center">
                <.icon name="hero-phone" class="w-4 h-4 shrink-0 text-gray-400 mr-3" />
                <span class="text-sm text-gray-600"><%= @phone %></span>
              </li>

              <li class="flex items-center">
                <.icon name="hero-map-pin" class="w-4 h-4 shrink-0 text-gray-400 mr-3" />
                <span class="text-sm text-gray-600"><%= @address %></span>
              </li>
              <li class="flex items-center">
                <.icon name="hero-map-pin" class="w-4 h-4 shrink-0 text-gray-400 mr-3" />
                <span class="text-sm text-gray-600">Curionópolis</span>
              </li>
            </ul>
          </div>

          <div class="max-w-xs mx-auto mb-5">
            <a
              class="btn w-full text-white bg-indigo-500 hover:bg-indigo-600 group shadow-sm"
              href="#0"
            >
              WhatsApp <.icon name="hero-arrow-right" class="w-3 h-3" />
            </a>
          </div>

          <div class="text-center">
            <a class="text-sm text-indigo-500 font-medium hover:underline" href="#0">Site</a>
          </div>
        </div>
      </div>
    </aside>
    """
  end
end

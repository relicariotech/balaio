defmodule BalaioWeb.Components do
  use Phoenix.Component

  attr :color, :string, default: "bg-blue-500"

  def color_button(assigns) do
    ~H"""
    <button class={"py-2 px-4 #{assigns.color} text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75"}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end

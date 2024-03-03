defmodule BalaioWeb.CustomComponents do
  use Phoenix.Component
  use Phoenix.HTML

  def promo(assigns) do
    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in <%= @expiration %> hours
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

  def feature(assigns) do
    ~H"""
    <div class="feature">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end

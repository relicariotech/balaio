defmodule BalaioWeb.BusinessLive.FormComponent do
  use BalaioWeb, :live_component

  alias Balaio.Catalog
  alias Balaio.Catalog.Business

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage business records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="business-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:category]} type="text" label="Category" />
        <.input field={@form[:thumbnail]} type="text" label="Thumbnail" />
        <.input field={@form[:is_delivery]} type="checkbox" label="Is delivery" />
        <.input field={@form[:user_id]} type="hidden" />
        <-- Added this line <:actions>
          <.button phx-disable-with="Saving...">Save Business</.button>
        </-->
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{business: business} = assigns, socket) do
    changeset = Catalog.change_business(business)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_form(changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"business" => business_params}, socket) do
    changeset =
      socket.assigns.business
      |> Catalog.change_business(business_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"business" => business_params}, socket) do
    params = params_with_user_id(business_params, socket)
    # {:noreply, save_business(socket, params)}
    save_business(socket, socket.assigns.action, business_params)
  end

  def params_with_user_id(params, %{assigns: %{current_user: current_user}}) do
    params
    |> Map.put("user_id", current_user.id)
  end

  defp save_business(socket, :edit, business_params) do
    case Catalog.update_business(socket.assigns.business, business_params) do
      {:ok, business} ->
        notify_parent({:saved, business})

        {:noreply,
         socket
         |> put_flash(:info, "Business updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_business(socket, :new, business_params) do
    case Catalog.create_business(business_params) do
      {:ok, business} ->
        notify_parent({:saved, business})

        {:noreply,
         socket
         |> put_flash(:info, "Business created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  # def assign_business(%{assigns: %{current_user: user}} = socket) do
  #   assign(socket, :business, %Business{user_id: user.id})
  # end

  # defp assign_form(%{assigns: %{business: business}} = socket) do
  #   socket
  #   |> assign(:form, to_form(Catalog.change_business(business)))
  # end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

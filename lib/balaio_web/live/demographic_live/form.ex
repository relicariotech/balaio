defmodule BalaioWeb.DemographicLive.Form do
  use BalaioWeb, :live_component
  alias Balaio.Survey
  alias Balaio.Survey.Demographic

  # mount

  # update
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    socket
    |> assign(:form, to_form(Survey.change_demographic(demographic)))
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    {:noreply, save_demographic(socket, params)}
  end

  def params_with_user_id(params, %{assigns: %{current_user: current_user}}) do
    params
    |> Map.put("user_id", current_user.id)
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:create_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  # render
end

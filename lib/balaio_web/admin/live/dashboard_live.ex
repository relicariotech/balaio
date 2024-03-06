defmodule BalaioWeb.Admin.DashboardLive do
  use BalaioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")}
  end
end

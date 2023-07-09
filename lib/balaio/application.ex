defmodule Balaio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BalaioWeb.Telemetry,
      # Start the Ecto repository
      Balaio.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Balaio.PubSub},
      # Start Finch
      {Finch, name: Balaio.Finch},
      # Start the Endpoint (http/https)
      BalaioWeb.Endpoint
      # Start a worker by calling: Balaio.Worker.start_link(arg)
      # {Balaio.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Balaio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BalaioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

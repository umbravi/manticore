defmodule Manticore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ManticoreWeb.Telemetry,
      Manticore.Repo,
      {DNSCluster, query: Application.get_env(:manticore, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Manticore.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Manticore.Finch},
      # Start a worker by calling: Manticore.Worker.start_link(arg)
      # {Manticore.Worker, arg},
      # Start to serve requests, typically the last entry
      ManticoreWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Manticore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ManticoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

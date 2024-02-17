defmodule Scout.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScoutWeb.Telemetry,
      Scout.Repo,
      {DNSCluster, query: Application.get_env(:scout, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Scout.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Scout.Finch},
      # Start a worker by calling: Scout.Worker.start_link(arg)
      # {Scout.Worker, arg},
      # Start to serve requests, typically the last entry
      ScoutWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scout.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScoutWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

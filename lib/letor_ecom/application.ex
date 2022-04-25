defmodule LetorEcom.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LetorEcom.Repo,
      # Start the Telemetry supervisor
      LetorEcomWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LetorEcom.PubSub},
      # Start the Endpoint (http/https)
      LetorEcomWeb.Endpoint
      # Start a worker by calling: LetorEcom.Worker.start_link(arg)
      # {LetorEcom.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LetorEcom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LetorEcomWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

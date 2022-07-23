defmodule LetorEcom.MixProject do
  use Mix.Project

  def project do
    [
      app: :letor_ecom,
      version: "0.1.0",
      elixir: "~> 1.13.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LetorEcom.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:plug_cowboy, "~> 2.5"},

      # graphql Deps
      {:absinthe, "~> 1.6"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0"},
      {:dataloader, "~> 1.0"},

      # Authentication
      {:argon2_elixir, "~> 3.0"},
      {:guardian, "~> 2.2"},
      {:guardian_db, "~> 2.1"},
      {:guardian_phoenix, "~> 2.0"},

      # Utilities
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.11.1"},
      {:telemetry, "~> 1.0"},
      {:ex_doc, "~> 0.28.3", only: :dev, runtime: false},
      {:timex, "~> 3.7"},
      {:jason, "~> 1.3"},
      {:poison, "~> 5.0", override: true},
      {:hackney, "~> 1.18"},
      {:httpoison, "~> 1.8"},
      {:quantum, "~> 3.4"},
      {:ex_aws, "~> 2.2"},
      {:ex_aws_s3, "~> 2.3"},
      {:prom_ex, "~> 1.7"},
      {:oban, "~> 2.11"},
      # testing, phone and email
      {:ex_twilio, "~> 0.9.1"},
      {:ex_phone_number, "~> 0.2.1"},
      # email
      {:swoosh, "~> 1.3"},
      ## {:gen_smtp, "~> 1.2"},

      # uploads
      {:sweet_xml, "~> 0.7.2", override: true},
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0.11"},
      {:qr_code, "~> 2.2"},
      {:mogrify, "~> 0.9.1"},

      # Cors
      {:cors_plug, "~> 3.0"},

      # Facebook
      {:facebook, "~> 0.24.0"},

      # Geo-Location
      {:geolix, "~> 2.0"},
      {:geo, "~> 3.4"},
      {:geo_postgis, "~> 3.4"},

      # deployment
      {:distillery, "~> 2.1"},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end

defmodule PhoenixToastr.MixProject do
  use Mix.Project

  @project_url "https://github.com/fbettag/phoenix_toastr.ex"

  def project do
    [
      app: :phoenix_toastr,
      version: "0.1.0",
      elixir: "~> 1.7",
      source_url: @project_url,
      homepage_url: @project_url,
      name: "Phoenix Toastr Notifications",
      description: "Toastr Notifications for Phoenix Applications",
      package: package(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp package do
    [
      name: "phoenix_toastr",
      maintainers: ["Franz Bettag"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url},
      files: ~w(lib LICENSE README.md mix.exs)
    ]
  end

  defp aliases do
    [credo: "credo -a --strict"]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 0.15"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:credo, github: "rrrene/credo", only: [:dev, :test]}
    ]
  end
end

defmodule BardecoderEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :bardecoder_ex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      name: "bardecoder_ex",
      source_url: "https://github.com/denvera/bardecoder_ex",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:rustler, "~> 0.32.1"}
    ]
  end

  defp description() do
    "Simple binding to read QR codes using Rust bardecoder crate. Uses Rustler for bindings."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "bardecoder_ex",
      licenses: ["MIT"],
      files:
        ~w(lib .formatter.exs mix.exs README* native/bardecoder_ex_nif/Cargo* native/bardecoder_ex_nif/src),
      links: %{"GitHub" => "https://github.com/denvera/bardecoder_ex"}
    ]
  end
end

defmodule BardecoderEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :bardecoder_ex,
      version: "0.0.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
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
      {:rustler, "~> 0.22.0"}
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
      files: ~w(lib .formatter.exs mix.exs README* native/bardecoder_ex_nif/Cargo* native/bardecoder_ex_nif/src),
      links: %{"GitHub" => "https://github.com/denvera/bardecoder_ex"}
    ]
  end

end

# BardecoderEx

[![Hex.pm Version](https://img.shields.io/hexpm/v/bardecoder_ex.svg?style=flat-square)](https://hex.pm/packages/bardecoder_ex)

Simple binding to allow using [bardecoder](https://crates.io/crates/bardecoder) from Elixir. Uses Rustler for bindings.

## Requirements
Working Rust toolchain.

## Installation

Add `bardecoder_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bardecoder_ex, "~> 0.1.0"}
  ]
end
```

## Examples

Detect and decode QR codes from a file supported by the Rust [image](https://crates.io/crates/image) crate.

```elixir
  BardecoderEx.detect_qr_codes(File.read!("./test.png"))
  {:ok,
  [
    ok: {%{
        __struct__: Bardecoder.Metadata,
        bounds: [{474, 674}, {569, 674}, {569, 770}, {474, 770}],
        ecc_level: 1,
        modules: 41,
        version: 6
      },
      "The QR Code Content!"}
  ]}

```

Documentation can be found at [https://hexdocs.pm/bardecoder_ex](https://hexdocs.pm/bardecoder_ex).
# NIF for Elixir.BardecoderEx

## To build the NIF module:

- Make sure your projects `mix.exs` has the `:rustler` compiler listed in the `project` function: `compilers: [:rustler] ++ Mix.compilers()` If there already is a `:compilers` list, you should append `:rustler` to it.
- Add your crate to the `rustler_crates` attribute in the `project function. [See here](https://hexdocs.pm/rustler/basics.html#crate-configuration).
- Your NIF will now build along with your project.

## To load the NIF:

```elixir
defmodule BardecoderEx do
    use Rustler, otp_app: :bardecoder_ex, crate: "bardecoder_ex_nif"

    # When your NIF is loaded, it will override this function.
    def detect_qr_codes(_arg1), do: :erlang.nif_error(:nif_not_loaded)
end
```
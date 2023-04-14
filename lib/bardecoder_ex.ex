defmodule BardecoderEx.Metadata do
  @moduledoc """
  Metadata of a QR code
  """
  defstruct version: 1,
            modules: 21,
            ecc_level: 0,
            mask: 0,
            bounds: []

  @typedoc """
  Barcode metadata
  * `:version`: Version of the QR Code
  * `:modules`: The number of modules of the QR Code
  * `:ecc_level`: Error correction level of the QR Code
  * `:bounds`: The four boundary points of the QR Code

  """
  @type t :: %__MODULE__{
          version: pos_integer(),
          modules: pos_integer(),
          ecc_level: non_neg_integer(),
          mask: non_neg_integer(),
          bounds: list({integer(), integer()})
        }
end

defmodule BardecoderEx do
  @moduledoc """
  Call out to nif to detect barcodes using Rust bardecoder crate.
  """
  use Rustler, otp_app: :bardecoder_ex, crate: :bardecoder_ex_nif

  @doc """
  Detect a QR code in the image provided as a binary()

  Returns `[{:ok, {%BardecoderEx.Metadata{}, String.t()}} | {:error, String.t()}]`.

  ## Examples

      iex> BardecoderEx.detect_qr_codes(File.read!("./test.png"))
      {:ok,
      [
        ok: {%{
            __struct__: BardecoderEx.Metadata,
            bounds: [{474, 674}, {569, 674}, {569, 770}, {474, 770}],
            ecc_level: 1,
            modules: 41,
            version: 6
          },
          "The contents of the QR code!"}
      ]}

  """
  @spec detect_qr_codes(binary()) ::
          {:ok, [{:ok, {BardecoderEx.Metadata.t(), String.t()}} | {:error, String.t()}]}
          | {:error, String.t()}
  def detect_qr_codes(_image_bytes), do: :erlang.nif_error(:nif_not_loaded)
end

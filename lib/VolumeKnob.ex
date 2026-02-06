defmodule VolumeKnob do
  @moduledoc """
  Membrane filter: changes audio volume 
  Filter: Receives stream from other elements, processes it and send it to subsequent elements
"""
  use Membrane.Filter
  alias Membrane.RawAudio

  def_input_pad :input, accepted_format: RawAudio, flow_control: :auto
  def_output_pad :output, accepted_format: RawAudio, flow_control: :auto

  def_options gain: [
    spec: float(),
    description: """
      Factor by which volume will be cahnged.
      Gain > 1 increases volume, gain < 1 reduces it.
    """
  ]

  @impl true 
  def handle_init(_ctx, options) do
    {[], %{gain: options.gain}}
  end

  @impl true 
  def handle_buffer(:input, buffer, ctx, state) do
    stream_format = ctx.pads.input.stream_format
    sample_size = RawAudio.sample_size(stream_format)
    payload = 
      for <<sample::binary-size(sample_size) <- buffer.payload>>, into: <<>> do
        value = RawAudio.sample_to_value(sample, stream_format)
        scaled_value = round(value * state.gain)
        RawAudio.value_to_sample(scaled_value, stream_format)
      end

    buffer = %Membrane.Buffer{buffer | payload: payload}
    {[buffer: {:output, buffer}], state}
  end

end

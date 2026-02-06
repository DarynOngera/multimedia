defmodule MyPipeline do
  use Membrane.Pipeline

  @impl true 
  def handle_init(_ctx, mp3_url) do
    spec = 
      child(%Membrane.Hackney.Source{
        location: mp3_url, hackney_opts: [follow_redirect: true]
      })
      |> child(Membrane.MP3.MAD.Decoder)
      |> child(%VolumeKnob{gain: 0.1})
      |> child(Membrane.PortAudio.Sink)

    {[spec: spec], %{}}
  end
end

#mp3_url = "https://raw.githubusercontent.com/membraneframework/membrane_demo/master/simple_pipeline/sample.mp3"

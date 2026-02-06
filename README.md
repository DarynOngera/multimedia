# Mm

As I continue to learn elixir, here is a tutorial project for basic multimedia in elixir using membrane.
The project has a basic pipeline that allows fetching and playback of audio. A volume knob element (filter) for adjusting volume (gain) has also been implemented. 

## Testing

```
iex(1) > Membrane.Pipeline.start_link(MyPipeline, mp3_url)
```

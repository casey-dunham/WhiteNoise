# MatchedNoise.wav

The single sound in WhiteNoise is the locally generated recreation Casey
approved on October 13, 2026. It uses independent stereo Gaussian noise shaped
to the measured frequency profile of the reference at 4:08:09:
https://www.youtube.com/watch?v=nMfPqeZjc2c&t=14889s

This 30-second, 48 kHz, stereo PCM asset preserves the approved preview's exact
samples except for removing its 50 ms start/end fades. The underlying waveform
was generated on a periodic Fourier grid, so it can repeat without a fade to
silence. It contains generated noise, not a segment of the YouTube recording.

The source preview and spectral profile are in
`/Users/casey/white-noise-feasibility/`. The bundled WAV is the playback source;
the app does not need that folder or network access.

# WhiteNoise

**Ambient noise for your menu bar.**

A lightweight macOS menu bar app that plays one warm, custom-generated stereo noise sound to help you focus, relax, or sleep. The sound is bundled with the app and loops continuously, with no network requests or additional downloads.

## Features

- **One custom sound** -- a locally generated stereo noise loop shaped to the approved reference sound
- **Volume control** -- simple slider, always accessible
- **Sleep timer** -- preset durations (15m, 30m, 1h, 2h) with a gentle 10-second fade-out before stopping
- **Menu bar native** -- lives in your menu bar with a minimal dark popover UI; no Dock icon
- **Zero third-party dependencies** -- pure Swift with one bundled PCM audio file

## Tech Stack

- **Swift** + **SwiftUI** for the UI
- **AVFoundation** (`AVAudioPlayer`) for continuous looping playback
- **AppKit** for menu bar integration (`NSStatusItem` / `NSPopover`)
- **Combine** for reactive state updates
- Targets **macOS 13.0+** (Ventura and later)

## Build

Requires Xcode command-line tools (`swiftc`).

```bash
git clone <repo-url> && cd WhiteNoise
chmod +x build.sh
./build.sh
```

The build script compiles a signed `.app` bundle into `build/WhiteNoise.app`.

```bash
# Run it
open build/WhiteNoise.app

# Or install to Applications
cp -r build/WhiteNoise.app /Applications/
```

## License

MIT

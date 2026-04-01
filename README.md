# WhiteNoise

**Ambient noise for your menu bar.**

A lightweight macOS menu bar app that generates white noise and brown noise to help you focus, relax, or sleep. No files to download, no network requests -- just pure, algorithmically generated sound.

## Features

- **White & brown noise** -- switch between warm white noise (low-pass filtered) and deep brown noise (integrated random walk) in one click
- **Volume control** -- simple slider, always accessible
- **Sleep timer** -- preset durations (15m, 30m, 1h, 2h) with a gentle 10-second fade-out before stopping
- **Menu bar native** -- lives in your menu bar with a minimal dark popover UI; no Dock icon
- **Zero dependencies** -- pure Swift, no third-party libraries, no audio files

## Tech Stack

- **Swift** + **SwiftUI** for the UI
- **AVFoundation** (`AVAudioEngine` / `AVAudioSourceNode`) for real-time audio synthesis
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

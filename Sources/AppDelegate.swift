import AppKit
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private let audioEngine = AudioEngine()
    private var cancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 380)
        popover.behavior = .transient

        let hostingController = NSHostingController(
            rootView: ContentView(audioEngine: audioEngine)
                .preferredColorScheme(.dark)
        )
        hostingController.view.appearance = NSAppearance(named: .darkAqua)
        popover.contentViewController = hostingController

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "waveform.circle",
                accessibilityDescription: "WhiteNoise"
            )
            button.action = #selector(togglePopover)
            button.target = self
        }

        cancellable = audioEngine.$isPlaying
            .receive(on: RunLoop.main)
            .sink { [weak self] playing in
                let name = playing ? "waveform.circle.fill" : "waveform.circle"
                self?.statusItem.button?.image = NSImage(
                    systemSymbolName: name,
                    accessibilityDescription: "WhiteNoise"
                )
            }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}

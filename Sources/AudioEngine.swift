import AVFoundation
import Combine

class AudioEngine: ObservableObject {
    @Published var isPlaying = false
    @Published var volume: Float = 1.0 {
        didSet { player?.volume = volume }
    }
    @Published var timerRemaining: Int = 0
    @Published var timerActive = false

    private var player: AVAudioPlayer?
    private var countdownTimer: Timer?
    private var savedVolume: Float = 1.0

    func toggle() {
        isPlaying ? pause() : start()
    }

    func start() {
        guard !isPlaying else { return }

        do {
            if player == nil {
                guard let url = Bundle.main.url(forResource: "MatchedNoise", withExtension: "wav") else {
                    throw CocoaError(.fileNoSuchFile)
                }
                let player = try AVAudioPlayer(contentsOf: url)
                player.numberOfLoops = -1
                player.volume = volume
                player.prepareToPlay()
                self.player = player
            }
            isPlaying = player?.play() == true
        } catch {
            print("Audio engine error: \(error)")
        }
    }

    func stop() {
        pause()
        player?.currentTime = 0
        cancelTimer()
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    // MARK: - Sleep Timer

    func startTimer(minutes: Int) {
        cancelTimer()
        if !isPlaying { start() }

        savedVolume = volume
        timerRemaining = minutes * 60
        timerActive = true

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] timer in
            guard let self = self, self.timerActive else {
                timer.invalidate()
                return
            }

            self.timerRemaining -= 1

            // Gentle fade out over last 10 seconds
            if self.timerRemaining <= 10 && self.timerRemaining > 0 {
                self.volume = self.savedVolume * (Float(self.timerRemaining) / 10.0)
            }

            if self.timerRemaining <= 0 {
                timer.invalidate()
                self.volume = self.savedVolume
                self.stop()
            }
        }
    }

    func cancelTimer() {
        let wasActive = timerActive
        countdownTimer?.invalidate()
        countdownTimer = nil
        timerActive = false
        timerRemaining = 0
        if wasActive {
            volume = savedVolume
        }
    }

}

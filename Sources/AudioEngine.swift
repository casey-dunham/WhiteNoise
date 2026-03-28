import AVFoundation
import Combine

enum NoiseType: String, CaseIterable, Identifiable {
    case white = "White"
    case brown = "Brown"
    var id: String { rawValue }
}

class AudioEngine: ObservableObject {
    @Published var isPlaying = false
    @Published var volume: Float = 1.0
    @Published var noiseType: NoiseType = .white
    @Published var timerRemaining: Int = 0
    @Published var timerActive = false

    private var engine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private var countdownTimer: Timer?
    private var savedVolume: Float = 1.0

    func toggle() {
        isPlaying ? stop() : start()
    }

    func start() {
        guard engine == nil else { return }

        let engine = AVAudioEngine()
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!

        // Noise state lives entirely on the audio thread — no main-thread access
        var renderType: NoiseType = self.noiseType
        var brownValue: Float = 0
        var lpFilter: Float = 0 // low-pass filter state for warm white noise

        let sourceNode = AVAudioSourceNode(format: format) {
            [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }

            let vol = self.volume
            let type = self.noiseType

            if type != renderType {
                renderType = type
                brownValue = 0
            }

            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)

            for frame in 0..<Int(frameCount) {
                let sample: Float
                switch type {
                case .white:
                    // Deep warm noise — between white and brown (~900Hz cutoff)
                    let raw = Float.random(in: -1...1)
                    lpFilter = 0.12 * raw + 0.88 * lpFilter
                    sample = min(1, max(-1, lpFilter * 4.0)) * vol
                case .brown:
                    // Integrated white noise with decay
                    brownValue = brownValue * 0.97 + Float.random(in: -1...1) * 0.03
                    sample = min(1, max(-1, brownValue * 3.5)) * vol
                }

                for buffer in ablPointer {
                    let buf = UnsafeMutableBufferPointer<Float>(buffer)
                    if frame < buf.count {
                        buf[frame] = sample
                    }
                }
            }

            return noErr
        }

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: engine.mainMixerNode, format: format)

        do {
            try engine.start()
            self.engine = engine
            self.sourceNode = sourceNode
            isPlaying = true
        } catch {
            print("Audio engine error: \(error)")
        }
    }

    func stop() {
        engine?.stop()
        if let node = sourceNode { engine?.detach(node) }
        engine = nil
        sourceNode = nil
        isPlaying = false
        cancelTimer()
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

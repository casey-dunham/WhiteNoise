import SwiftUI

struct ContentView: View {
    @ObservedObject var audioEngine: AudioEngine

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "waveform")
                    .font(.system(size: 14, weight: .semibold))
                Text("WhiteNoise")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)

            // Play / Pause
            Button(action: { audioEngine.toggle() }) {
                ZStack {
                    Circle()
                        .fill(audioEngine.isPlaying
                            ? Color.white.opacity(0.15)
                            : Color.white.opacity(0.06))
                        .frame(width: 72, height: 72)

                    Image(systemName: audioEngine.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .offset(x: audioEngine.isPlaying ? 0 : 2)
                }
            }
            .buttonStyle(.plain)

            // Noise type selector
            HStack(spacing: 6) {
                ForEach(NoiseType.allCases) { type in
                    Button(action: { audioEngine.noiseType = type }) {
                        Text(type.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(
                                audioEngine.noiseType == type
                                    ? Color.black : Color.white.opacity(0.6)
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(
                                audioEngine.noiseType == type
                                    ? Color.white
                                    : Color.white.opacity(0.06)
                            )
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }

            // Volume slider
            HStack(spacing: 10) {
                Image(systemName: "speaker.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))
                    .frame(width: 14)

                Slider(value: $audioEngine.volume, in: 0...1)
                    .accentColor(.white)

                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))
                    .frame(width: 14)
            }

            // Sleep timer
            VStack(spacing: 10) {
                HStack {
                    Text("Sleep Timer")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                    Spacer()
                    if audioEngine.timerActive {
                        Text(formatTime(audioEngine.timerRemaining))
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                HStack(spacing: 5) {
                    ForEach([15, 30, 60, 120], id: \.self) { mins in
                        Button(action: { audioEngine.startTimer(minutes: mins) }) {
                            Text(mins < 60 ? "\(mins)m" : "\(mins / 60)h")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }

                    if audioEngine.timerActive {
                        Button(action: { audioEngine.cancelTimer() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.red.opacity(0.7))
                                .frame(width: 32)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Spacer().frame(height: 2)

            // Quit button
            Button(action: {
                audioEngine.stop()
                NSApp.terminate(nil)
            }) {
                Text("Quit WhiteNoise")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.25))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(width: 280)
        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let h = totalSeconds / 3600
        let m = (totalSeconds % 3600) / 60
        let s = totalSeconds % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%d:%02d", m, s)
    }
}

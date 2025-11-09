//
//  SongLiveActivityView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 08/11/25.
//

import AppIntents
import SwiftUI

struct SongLiveActivityView: View {
    
    let image: String
    let title: String
    let artist: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(.rect(corners: .concentric()))
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(artist)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SongPlaybackView: View {
    let state: PlayingSongAttributes.ContentState
    
    @State private var sliderValue: Double
    @State private var isEditing = false
    
    init(state: PlayingSongAttributes.ContentState) {
        self.state = state
        _sliderValue = State(initialValue: state.currentTime)
    }
    
    var body: some View {
        VStack(spacing: 0) {
//            Slider(
//                value: Binding(
//                    get: { sliderValue },
//                    set: { newValue in
//                        let clamped = min(max(0, newValue), max(state.duration, 0))
//                        sliderValue = clamped
//                    }
//                ),
//                in: 0...max(state.duration, 1),
//                onEditingChanged: handleEditingChanged
//            )
//            .tint(.white.opacity(0.5))
//            .sliderThumbVisibility(.hidden)
//            .frame(height: 10)
//            .disabled(state.duration == 0)
            
            GeometryReader { geo in
                HStack(spacing: 10) {
                    Text(formatTime(sliderValue))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ZStack(alignment: .leading) {
                        // Background track
                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 6)
                        
                        // Foreground progress
                        // Calculate progress safely, avoiding division by zero
                        let progress = (state.duration > 0) ? (state.currentTime / state.duration) : 0.0
                        Capsule()
                            .fill(Color.white)
                            .frame(width: geo.size.width * progress, height: 6)
                    }
                    .frame(height: 6)
                    
                    Text("- \(formatTime(state.duration))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 10)
            
//            HStack {
//                Text(formatTime(sliderValue))
//                Spacer()
//                Text(formatTime(state.duration))
//            }
//            .font(.caption)
//            .foregroundStyle(.secondary)
            
            HStack(spacing: 40) {
                Button(intent: PreviousSongIntent()) {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                
                Button(intent: TogglePlaybackIntent()) {
                    Image(systemName: state.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .frame(width: 30)
                
                Button(intent: NextSongIntent()) {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 5)
        }
        .onAppear {
            sliderValue = state.currentTime
        }
        .onChange(of: state.currentTime) { _, newValue in
            guard !isEditing else { return }
            sliderValue = newValue
        }
        .onChange(of: state.duration) { _, newDuration in
            guard !isEditing else { return }
            sliderValue = min(sliderValue, newDuration)
        }
    }
    
    private func handleEditingChanged(_ editing: Bool) {
        isEditing = editing
        guard !editing else { return }
        
        let target = min(max(0, sliderValue), state.duration)
        Task {
            do {
                _ = try await SeekSongIntent(targetTime: target).perform()
            } catch {
                print("SeekSongIntent failed: \(error)")
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        guard time.isFinite, time >= 0 else { return "--:--" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    SongLiveActivityView(image: "leh", title: "Afterparty", artist: "Wegz")
}

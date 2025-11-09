//
//  SongPlayerView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import SwiftUI

struct SongPlayerView: View {
    
    @Environment(AudioPlayerManager.self) var audioPlayerManager
    
    var body: some View {
        @Bindable var playerManager = audioPlayerManager
        
        VStack(spacing: 0) {
            Slider(
                value: $playerManager.currentSongTime,
                in: 0...audioPlayerManager.currentSongDuration
            ) { editing in
                if editing {
                    audioPlayerManager.beginScrubbing()
                } else {
                    audioPlayerManager.completeScrubbing(at: playerManager.currentSongTime)
                }
            }
            .tint(.white.opacity(0.5))
            .sliderThumbVisibility(.hidden)
            
            HStack {
                Text(formatTime(audioPlayerManager.currentSongTime))
                Spacer()
                Text(formatTime(audioPlayerManager.currentSongDuration))
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            HStack(spacing: 40) {
                Button {
                    audioPlayerManager.previousTrack()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
                
                Button {
                    audioPlayerManager.playPause()
                } label: {
                    Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
                .frame(width: 50, height: 50)
                
                Button {
                    audioPlayerManager.nextTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
            }
            .padding(.top, 30)
            
           HStack(spacing: 10) {
               Image(systemName: "speaker.fill")
                   .foregroundStyle(.white.opacity(0.5))
                   .font(.system(size: 14))
                   .padding(.bottom, 2)
               
               VolumeSliderView()
                   .frame(height: 20)
               
               Image(systemName: "speaker.wave.3.fill")
                   .foregroundStyle(.white.opacity(0.5))
                   .font(.system(size: 14))
                   .padding(.bottom, 2)
           }
           .padding(.top, 50)
        }
        .padding(.horizontal, 30)
        .animation(.default, value: audioPlayerManager.isPlaying)
    }
    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    SongPlayerView()
        .environment(AudioPlayerManager.preview())
}

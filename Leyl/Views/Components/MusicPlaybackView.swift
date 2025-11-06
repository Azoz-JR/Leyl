//
//  MusicPlaybackView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct MusicPlaybackView: View {
    
    let namespace: Namespace.ID
    @Binding var showSongView: Bool
    
    @Environment(AudioPlayerManager.self) var audioPlayerManager
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    var body: some View {
        switch placement {
        case .expanded:
            HStack(spacing: 10) {
                Image(audioPlayerManager.currentSong?.image ?? "aqareeb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(audioPlayerManager.currentSong?.title ?? "Song name")
                        .font(.system(size: 12))
                    Text(audioPlayerManager.currentSong?.artist ?? "Artist name")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        audioPlayerManager.playPause()
                    } label: {
                        Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 25)
            .contentShape(Rectangle())
            .onTapGesture {
                showSongView = true
            }
        default:
            HStack(spacing: 15) {
                Image(audioPlayerManager.currentSong?.image ?? "aqareeb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(audioPlayerManager.currentSong?.title ?? "Song name")
                        .font(.system(size: 12))
                    Text(audioPlayerManager.currentSong?.artist ?? "Artist name")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    audioPlayerManager.playPause()
                } label: {
                    Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
            .padding(.leading, 20)
            .padding(.trailing, 25)
            .contentShape(Rectangle())
            .onTapGesture {
                showSongView = true
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var showSongView = false
    
    MusicPlaybackView(namespace: namespace, showSongView: $showSongView)
        .environment(AudioPlayerManager())
}

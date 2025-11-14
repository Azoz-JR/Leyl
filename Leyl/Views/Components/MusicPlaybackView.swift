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
                    .matchedGeometryEffect(id: "albumArt", in: namespace)
                
                VStack(alignment: .leading, spacing: 2) {
                    ScrollingText(
                        text: audioPlayerManager.currentSong?.title ?? "Song name",
                        font: .system(size: 14, weight: .semibold),
                        availableWidth: 180
                    )
                    .frame(height: 16)
                    
//                    MarqueeText(text: audioPlayerManager.currentSong?.title ?? "Khesert Elsha3b", font: .systemFont(ofSize: 14, weight: .semibold), leftFade: 2, rightFade: 15, startDelay: 4, alignment: .leading)
//                        .matchedGeometryEffect(id: "title", in: namespace)
                    
                    Text(audioPlayerManager.currentSong?.artist ?? "Artist name")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "artist", in: namespace)
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
                    .matchedGeometryEffect(id: "playButton", in: namespace)

                    Button {
                        audioPlayerManager.nextTrack()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .matchedGeometryEffect(id: "forwardButton", in: namespace)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 25)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                showSongView = true
//            }
        default:
            HStack(spacing: 0) {
                Image(audioPlayerManager.currentSong?.image ?? "aqareeb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(.trailing, 10)
                    .matchedGeometryEffect(id: "albumArt", in: namespace)
                
                VStack(alignment: .leading, spacing: 2) {
                    ScrollingText(
                        text: audioPlayerManager.currentSong?.title ?? "Song name",
                        font: .system(size: 14, weight: .semibold),
                        availableWidth: 120
                    )
                    .frame(height: 16)
                    
//                    MarqueeText(text: audioPlayerManager.currentSong?.title ?? "Khesert Elsha3b", font: .systemFont(ofSize: 14, weight: .semibold), leftFade: 2, rightFade: 15, startDelay: 4, alignment: .leading)
//                        .matchedGeometryEffect(id: "title", in: namespace)
                    
                    Text(audioPlayerManager.currentSong?.artist ?? "Artist name")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "artist", in: namespace)
                }
                
                Spacer()
                
                Button {
                    audioPlayerManager.playPause()
                } label: {
                    Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .matchedGeometryEffect(id: "playButton", in: namespace)
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                showSongView = true
//            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var showSongView = false
    
    MusicPlaybackView(namespace: namespace, showSongView: $showSongView)
        .environment(AudioPlayerManager.preview())
}

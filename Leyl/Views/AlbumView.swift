//
//  AlbumView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 10/11/25.
//

import SwiftUI

struct AlbumView: View {
    
    let album: Album
    @Environment(AudioPlayerManager.self) var audioPlayerManager
    
    @State private var allowDismissalGesture: AllowedNavigationDismissalGestures = .none

    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image(album.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 20)
                
                VStack(spacing: 4) {
                    Text(album.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(album.artist)
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                    
                    if !album.year.isEmpty {
                        Text(album.year)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.top, 20)
                
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.5))
                        .padding(.horizontal, 15)
                    
                    ForEach(Array(album.songs.enumerated()), id: \.element.id) { index, song in
                        Button {
                            audioPlayerManager.playSong(song)
                        } label: {
                            HStack(spacing: 15) {
                                if audioPlayerManager.currentSong?.id == song.id {
                                    Image(systemName: audioPlayerManager.isPlaying ? "waveform" : "waveform.low")
                                        .foregroundStyle(Color.accentColor)
                                        .font(.body)
                                        .frame(width: 20, alignment: .center)
                                        .symbolEffect(.bounce, options: .repeat(.continuous), isActive: audioPlayerManager.isPlaying)
                                        .symbolColorRenderingMode(.gradient)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.body)
                                        .foregroundStyle(.white.opacity(0.5))
                                        .frame(width: 20, alignment: .leading)
                                }
                                
                                Text(song.title)
                                    .font(.body)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 15)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        if index < album.songs.count - 1 {
                            Divider()
                                .background(Color.white.opacity(0.5))
                                .padding(.leading, 55)
                                .padding(.trailing, 15)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                        .padding(.horizontal, 15)
                }
                .padding(.top, 30)
            }
            .padding(.bottom, 100)
        }
        .animation(.easeInOut, value: audioPlayerManager.isPlaying)
        .navigationBarTitleDisplayMode(.inline)
        .navigationAllowDismissalGestures(allowDismissalGesture)
        .task {
            Task {
                try? await Task.sleep(for: .seconds(1))
                allowDismissalGesture = .all
            }
        }
    }
}

#Preview {
    NavigationStack {
        AlbumView(album: Album(
            title: "Aqareeb",
            artist: "Wegz",
            imageName: "aqareeb",
            year: "2024",
            songs: [
                Song(title: "Khesert El Sha3b", artist: "Wegz", image: "aqareeb", url: URL(string: "file://")!, colors: ["#A68563", "#A68563"]),
                Song(title: "Afterparty", artist: "Wegz", image: "aqareeb", url: URL(string: "file://")!, colors: ["#A68563", "#A68563"])
            ],
            colors: ["#A68563", "#A68563"]
        ))
        .environment(AudioPlayerManager.preview())
    }
}

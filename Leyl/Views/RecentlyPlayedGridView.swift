//
//  RecentlyPlayedGridView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 11/11/25.
//

import SwiftUI

struct RecentlyPlayedGridView: View {
    
    @Namespace var namespace
    let songs: [Song]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20, pinnedViews: []) {
                ForEach(songs) { song in
                    NavigationLink {
                        AlbumView(album: createAlbumFromSong(song))
                            .navigationTransition(.zoom(sourceID: song.id, in: namespace))
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Image(song.image ?? "aqareeb")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .matchedTransitionSource(id: song.id, in: namespace)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(song.title)
                                    .font(.system(size: 14, weight: .medium))
                                    .lineLimit(1)
                                    .foregroundStyle(.primary)
                                
                                Text(song.artist)
                                    .font(.system(size: 12))
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .padding(.bottom, 100)
        }
        .navigationTitle("Recently Played")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func createAlbumFromSong(_ song: Song) -> Album {
        Album(
            title: song.title,
            artist: song.artist,
            imageName: song.image ?? "aqareeb",
            year: "",
            songs: [song],
            colors: song.colors
        )
    }
}

#Preview {
    NavigationStack {
        RecentlyPlayedGridView(
            songs: [
                Song(title: "Test Song 1", artist: "Artist 1", image: "leh", url: URL(string: "file://")!, colors: ["#000000", "#FFFFFF"]),
                Song(title: "Test Song 2", artist: "Artist 2", image: "leh", url: URL(string: "file://")!, colors: ["#000000", "#FFFFFF"])
            ]
        )
        .environment(AudioPlayerManager.preview())
    }
}


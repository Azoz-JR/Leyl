//
//  SectionView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct SectionView: View {
    
    @Namespace var namespace
    @State private var allowDismissalGesture: AllowedNavigationDismissalGestures = .none
    
    let section: Section
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if case .tappable(let destination) = section.type {
                NavigationLink {
                    destination()
                } label: {
                    SectionHeader(title: section.title, type: section.type)
                }
                .buttonStyle(.plain)
            } else {
                SectionHeader(title: section.title, type: section.type)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(section.items.enumerated(), id: \.offset) { index, item in
                        if let song = item.song {
                            NavigationLink {
                                AlbumView(album: createAlbumFromSong(song))
                                    .navigationTransition(.zoom(sourceID: "section\(index)(\(section.id))item(\(item.id))", in: namespace))
                            } label: {
                                SectionItemCard(item: item)
                                    .matchedTransitionSource(id: "section\(index)(\(section.id))item(\(item.id))", in: namespace)
                            }
                            .buttonStyle(.plain)
                        } else if let album = item.album {
                            NavigationLink {
                                AlbumView(album: album)
                                    .navigationTransition(.zoom(sourceID: "section\(index)(\(section.id))item(\(item.id))", in: namespace))
                            } label: {
                                SectionItemCard(item: item)
                                    .matchedTransitionSource(id: "section\(index)(\(section.id))item(\(item.id))", in: namespace)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink {
                                SongDetailView()
                                    .navigationTransition(.zoom(sourceID: "section\(index)(\(section.id))item(\(item.id))", in: namespace))
                            } label: {
                                SectionItemCard(item: item)
                                    .matchedTransitionSource(id: "section\(index)(\(section.id))item(\(item.id))", in: namespace)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 24)
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
        ScrollView {
            SectionView(section: Section(
                title: "Recently Played",
                type: .simple,
                items: [
                    SectionItem(imageName: "leh", title: "Playlist 1", subtitle: "Artist 1"),
                    SectionItem(imageName: "leh", title: "Playlist 2", subtitle: "Artist 2"),
                    SectionItem(imageName: "leh", title: "Playlist 3", subtitle: "Artist 3")
                ]
            ))
        }
    }
}


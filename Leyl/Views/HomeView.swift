//
//  HomeView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(AudioPlayerManager.self) var audioPlayerManager
    @State private var scrollOffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    @State private var hideImage: Bool = false
    @State private var sections: [Section] = []
    @State private var topPicks: [TopPickItem] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    TopPicksSectionView(items: topPicks)
                    
                    ForEach(sections) { section in
                        SectionView(section: section)
                    }
                }
                .padding(.top, 62)
            }
            .onScrollGeometryChange(for: Double.self) { geo in
                geo.contentOffset.y
            } action: { _, newValue in
                print("Scroll value: \(newValue) - topInsets: \(safeAreaInsets.top)")
                scrollOffset = newValue
                withAnimation(.easeInOut) {
                    hideHeader = scrollOffset > -(safeAreaInsets.top - 10)
                    hideImage = scrollOffset > -(safeAreaInsets.top - 20)
                }
            }
            .overlay(alignment: .top) {
                Color.black.opacity(0.9).blur(radius: 40)
                    .frame(height: safeAreaInsets.top + safeAreaInsets.top)
                    .frame(width: 1000)
                    .offset(y: -safeAreaInsets.top)
                    .ignoresSafeArea()
            }
            .overlay(alignment: .top) {
                HStack {
                    Text("Home")
                        .font(.system(size: 32, weight: .bold))
                        .opacity(hideHeader ? 0 : 1)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Profile button tapped")
                    }) {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    }
                    .opacity(hideImage ? 0 : 1)
                }
                .padding(.horizontal)
            }
        }
        .task {
            loadSections()
            loadTopPicks()
        }
    }
    
    private func loadTopPicks() {
        let albums = audioPlayerManager.albums
        
        var picks: [TopPickItem] = []
        
        for album in albums {
            picks.append(
                TopPickItem(
                    category: "New Release",
                    imageName: album.imageName,
                    type: .album(name: album.title, artist: album.artist, year: album.year, colors: album.colors),
                    album: album
                )
            )
        }
        
        if !albums.isEmpty {
            picks.append(TopPickItem(
                category: "Listen again",
                imageName: albums[0].imageName,
                type: .album(name: albums[0].title, artist: albums[0].artist, year: albums[0].year, colors: ["#2C3F43", "#7D8987"]),
                album: albums[0]
            ))
        }
        
        topPicks = picks
    }
    
    private func loadSections() {
        let albums = audioPlayerManager.albums
        let allSongs = audioPlayerManager.songs
        
        let randomSongs = allSongs.shuffled().prefix(8)
        let recentlyPlayedItems = randomSongs.map { song in
            SectionItem(
                imageName: song.image ?? "aqareeb",
                title: song.title,
                subtitle: song.artist,
                song: song
            )
        }
        
        let newReleasesItems = albums.map { album in
            SectionItem(
                imageName: album.imageName,
                title: album.title,
                subtitle: album.artist,
                album: album
            )
        }
        
        let popularAlbumsItems = albums.map { album in
            SectionItem(
                imageName: album.imageName,
                title: album.title,
                subtitle: album.artist,
                album: album
            )
        }
        
        let trendingNowItems = albums.map { album in
            SectionItem(
                imageName: album.imageName,
                title: album.title,
                subtitle: album.artist,
                album: album
            )
        }
        
        let discoverMoreItems = albums.map { album in
            SectionItem(
                imageName: album.imageName,
                title: album.title,
                subtitle: album.artist,
                album: album
            )
        }
        
        sections = [
            Section(
                title: "Recently Played",
                type: .tappable(destination: {
                    AnyView(RecentlyPlayedGridView(songs: Array(randomSongs)))
                }),
                items: recentlyPlayedItems
            ),
            Section(
                title: "New Releases",
                type: .simple,
                items: newReleasesItems
            ),
            Section(
                title: "Popular Albums",
                type: .simple,
                items: popularAlbumsItems
            ),
            Section(
                title: "Trending Now",
                type: .simple,
                items: trendingNowItems
            ),
            Section(
                title: "Discover More",
                type: .simple,
                items: discoverMoreItems
            )
        ]
    }
}

#Preview {
    HomeView()
        .environment(AudioPlayerManager.preview())
        .readSafeAreaInsets()
}

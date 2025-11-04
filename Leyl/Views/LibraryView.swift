//
//  LibraryView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct LibraryView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var scrollOffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    @State private var hideImage: Bool = false
    
    let mockArtists = ["The Weeknd", "Taylor Swift", "Drake", "Billie Eilish", "Post Malone", "Ariana Grande", "Ed Sheeran", "Dua Lipa"]
    let mockPlaylists = ["Recently Played", "Liked Songs", "My Playlist 1", "Chill Vibes", "Workout Mix"]
    let mockAlbums = ["After Hours", "Midnights", "Certified Lover Boy", "Happier Than Ever", "Hollywood's Bleeding"]
    let mockDownloaded = ["Downloaded Album 1", "Downloaded Album 2", "Downloaded Album 3", "Downloaded Album 4"]
    let mockMadeForYou = ["Made for You Mix 1", "Made for You Mix 2", "Your Top Songs", "On Repeat"]
    let mockRecentArtists = ["New Artist 1", "New Artist 2", "New Artist 3", "New Artist 4"]
    let mockRecentAlbums = ["New Album 1", "New Album 2", "New Album 3", "New Album 4"]
    let mockGenres = ["Pop", "Hip-Hop", "Rock", "Electronic", "R&B", "Country", "Jazz"]
    let mockAllPlaylists = ["My Playlist 1", "My Playlist 2", "My Playlist 3", "Chill Vibes", "Workout Mix", "Party Mix"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    sectionView(title: "Recently Played", items: mockPlaylists)
                    
                    sectionView(title: "Artists", items: mockArtists)
                    
                    sectionView(title: "Albums", items: mockAlbums)
                    
                    sectionView(title: "Songs", items: mockPlaylists)
                    
                    sectionView(title: "Downloaded Music", items: mockDownloaded)
                    
                    sectionView(title: "Made for You", items: mockMadeForYou)
                    
                    sectionView(title: "Recently Added Artists", items: mockRecentArtists)
                    
                    sectionView(title: "Recently Added Albums", items: mockRecentAlbums)
                    
                    sectionView(title: "Genres", items: mockGenres)
                    
                    sectionView(title: "All Playlists", items: mockAllPlaylists)
                }
                .padding(.horizontal)
                .padding(.top, 62)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onScrollGeometryChange(for: Double.self) { geo in
                geo.contentOffset.y
            } action: { _, newValue in
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
                    Text("Library")
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
    }
    
    private func sectionView(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 20).bold())
                .foregroundColor(.primary)
            
            ForEach(items, id: \.self) { item in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Text(item)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LibraryView()
        .readSafeAreaInsets()
}


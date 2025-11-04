//
//  NewView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct NewView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var scrollOffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    @State private var hideImage: Bool = false
    
    let mockNewReleases = ["New Album 1", "New Album 2", "New Album 3", "New Album 4", "New Album 5"]
    let mockFeatured = ["Featured Artist 1", "Featured Artist 2", "Featured Artist 3"]
    let mockCharts = ["Top Songs Chart", "Hot Albums", "Rising Artists"]
    let mockCurated = ["Curated Playlist 1", "Curated Playlist 2", "Curated Playlist 3"]
    let mockHotRightNow = ["Hot Track 1", "Hot Track 2", "Hot Track 3", "Hot Track 4", "Hot Track 5"]
    let mockRecentlyAdded = ["Recently Added 1", "Recently Added 2", "Recently Added 3", "Recently Added 4"]
    let mockDiscover = ["Discover Weekly", "Daily Mix 1", "Daily Mix 2", "Release Radar"]
    let mockTrending = ["Trending Artist 1", "Trending Artist 2", "Trending Artist 3", "Trending Artist 4"]
    let mockSingles = ["New Single 1", "New Single 2", "New Single 3", "New Single 4", "New Single 5"]
    let mockEditorsPicks = ["Editor's Pick 1", "Editor's Pick 2", "Editor's Pick 3", "Editor's Pick 4"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    sectionView(title: "New Releases", items: mockNewReleases)
                    
                    sectionView(title: "Featured", items: mockFeatured)
                    
                    sectionView(title: "Charts", items: mockCharts)
                    
                    sectionView(title: "Curated for You", items: mockCurated)
                    
                    sectionView(title: "Hot Right Now", items: mockHotRightNow)
                    
                    sectionView(title: "Recently Added", items: mockRecentlyAdded)
                    
                    sectionView(title: "Discover", items: mockDiscover)
                    
                    sectionView(title: "Trending Artists", items: mockTrending)
                    
                    sectionView(title: "Latest Singles", items: mockSingles)
                    
                    sectionView(title: "Editor's Picks", items: mockEditorsPicks)
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
                    Text("New")
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
    NewView()
        .readSafeAreaInsets()
}


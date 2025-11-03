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
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
                .frame(height: 0)
                
                Group {
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
                withAnimation(.easeInOut) {
                    hideHeader = scrollOffset < (safeAreaInsets.top + 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("New")
                        .font(.system(size: 24).bold())
                        .frame(width: 100, alignment: .leading)
                        .opacity(hideHeader ? 0 : 1)
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .opacity(hideHeader ? 0 : 1)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
    
    private func sectionView(title: String, items: [String]) -> some View {
        Group {
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

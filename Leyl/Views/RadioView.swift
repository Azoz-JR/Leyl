//
//  RadioView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct RadioView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var scrollOffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    
    let mockStations = ["Hip-Hop Station", "Pop Radio", "Rock Station", "Electronic Dance", "Jazz Radio"]
    let mockHosts = ["Live with DJ Smith", "Morning Show", "Evening Mix", "Weekend Vibes"]
    let mockGenres = ["Country Radio", "Classical Station", "R&B Radio", "Indie Radio"]
    let mockRecentlyPlayed = ["Beats 1", "Hip-Hop Nation", "Pop Hits Radio", "Rock Classics"]
    let mockTopStations = ["Top 40 Radio", "Hip-Hop Central", "Pop Mix", "Rock Radio"]
    let mockLocal = ["Local FM 101.5", "City Radio 98.3", "Community Radio", "Local News"]
    let mockSports = ["Sports Talk Radio", "ESPN Radio", "Sports Center Live", "Game Day Radio"]
    let mockNews = ["News Radio 24/7", "Breaking News", "World News Radio", "Local News Station"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
                .frame(height: 0)
                
                Group {
                    sectionView(title: "Stations", items: mockStations)
                    
                    sectionView(title: "Live Shows", items: mockHosts)
                    
                    sectionView(title: "Genre Stations", items: mockGenres)
                    
                    sectionView(title: "Recently Played", items: mockRecentlyPlayed)
                    
                    sectionView(title: "Top Stations", items: mockTopStations)
                    
                    sectionView(title: "Local Radio", items: mockLocal)
                    
                    sectionView(title: "Sports Radio", items: mockSports)
                    
                    sectionView(title: "News Radio", items: mockNews)
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
                    Text("Radio")
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
    RadioView()
        .readSafeAreaInsets()
}

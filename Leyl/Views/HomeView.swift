//
//  HomeView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
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
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Text("Home")
//                        .font(.system(size: 32).bold())
//                        .frame(width: 100, alignment: .leading)
//                        .opacity(hideHeader ? 0 : 1)
//                }
//                .sharedBackgroundVisibility(.hidden)
//                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Image("profile")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 44, height: 44)
//                        .clipShape(Circle())
//                        .opacity(hideHeader ? 0 : 1)
//                }
//                .sharedBackgroundVisibility(.hidden)
//            }
        }
        .task {
            loadSections()
            loadTopPicks()
        }
    }
    
    private func loadTopPicks() {
        topPicks = [
            TopPickItem(
                category: "Made for you",
                imageName: "leh",
                type: .station(name: "Azoz Salah's Station")
            ),
            TopPickItem(
                category: "New Release",
                imageName: "leh",
                type: .album(name: "After Hours", artist: "The Weeknd", year: "2020")
            ),
            TopPickItem(
                category: "Listen again",
                imageName: "leh",
                type: .album(name: "Midnights", artist: "Taylor Swift", year: "2022")
            ),
            TopPickItem(
                category: "More from Nasser",
                imageName: "leh",
                type: .album(name: "Certified Lover Boy", artist: "Drake", year: "2021")
            ),
            TopPickItem(
                category: "Mood for you",
                imageName: "leh",
                type: .station(name: "Chill Vibes Radio")
            )
        ]
    }
    
    private func loadSections() {
        sections = [
            Section(
                title: "Recently Played",
                type: .simple,
                items: [
                    SectionItem(imageName: "leh", title: "Playlist 1", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Playlist 2", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Playlist 3", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Playlist 4", subtitle: "Artist Name")
                ]
            ),
            Section(
                title: "Made for You",
                type: .tappable(destination: {
                    AnyView(Text("Made for You Detail"))
                }),
                items: [
                    SectionItem(imageName: "leh", title: "Album 1", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Album 2", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Album 3", subtitle: "Artist Name")
                ]
            ),
            Section(
                title: "Popular Albums",
                type: .simple,
                items: [
                    SectionItem(imageName: "leh", title: "Album A", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Album B", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Album C", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Album D", subtitle: "Artist Name"),
                    SectionItem(imageName: "leh", title: "Album E", subtitle: "Artist Name")
                ]
            )
        ]
    }
}

#Preview {
    HomeView()
        .readSafeAreaInsets()
}

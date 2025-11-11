//
//  TopPicksSectionView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct TopPicksSectionView: View {
    let items: [TopPickItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Top Picks for You", type: .simple)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        NavigationLink {
                            if let album = item.album {
                                AlbumView(album: album)
                            } else {
                                SongDetailView()
                            }
                        } label: {
                            TopPickCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            TopPicksSectionView(items: [
                TopPickItem(
                    category: "Made for you",
                    imageName: "leh",
                    type: .station(name: "Azoz Salah's Station")
                ),
                TopPickItem(
                    category: "New Release",
                    imageName: "leh",
                    type: .album(name: "After Hours", artist: "The Weeknd", year: "2020", colors: ["000000", "FFFFFF"])
                ),
                TopPickItem(
                    category: "Listen again",
                    imageName: "leh",
                    type: .album(name: "Midnights", artist: "Taylor Swift", year: "2022", colors: ["000000", "FFFFFF"])
                )
            ])
        }
    }
}


//
//  SectionView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct SectionView: View {
    
    @Namespace var namespace
    
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
                HStack(spacing: 16) {
                    ForEach(section.items) { item in
                        NavigationLink {
                            if let album = item.album {
                                AlbumView(album: album)
                                    .navigationTransition(.zoom(sourceID: "section(\(section.id))song(\(item.id))", in: namespace))
                            } else {
                                SongDetailView()
                                    .navigationTransition(.zoom(sourceID: "section(\(section.id))song(\(item.id))", in: namespace))
                            }
                        } label: {
                            SectionItemCard(item: item)
                                .matchedTransitionSource(id: "section(\(section.id))song(\(item.id))", in: namespace)
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


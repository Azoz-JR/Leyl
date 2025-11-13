//
//  MainTabView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(AudioPlayerManager.self) var audioPlayerManager
    @State private var selectedTab = 0
    @State private var showSongView = false
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                Tab("Home", image: selectedTab == 0 ? "homeHighlight" : "home", value: 0) {
                    HomeView()
                }
                
                
                Tab("New", systemImage: "square.grid.2x2.fill", value: 1) {
                    NewView()
                }
                
                Tab("Radio", systemImage: "dot.radiowaves.left.and.right", value: 2) {
                    RadioView()
                }
                
                Tab("Library", systemImage: "music.note.square.stack.fill", value: 3) {
                    LibraryView()
                }
                
                Tab(value: 4, role: .search) {
                    NavigationStack {
                        SearchView()
                    }
                }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewBottomAccessory {
                if audioPlayerManager.currentSong != nil && !showSongView {
                    MusicPlaybackView(namespace: animation, showSongView: $showSongView)
                        .contentShape(Rectangle()) // Makes the whole area tappable
                        .onTapGesture {
                            // This is the animation trigger!
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                showSongView = true
                            }
                        }
                }
            }
            
//            if showSongView {
                SongView(namespace: animation, showSongView: $showSongView)
//                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(1)
//            }
        }
    }
}

#Preview {
    MainTabView()
        .tint(Color(hex: "#ff0436"))
        .preferredColorScheme(.dark)
        .environment(AudioPlayerManager.preview())
}

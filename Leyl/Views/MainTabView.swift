//
//  MainTabView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
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
            MusicPlaybackView()
        }
    }
}

#Preview {
    MainTabView()
        .tint(Color(hex: "#ff0436"))
        .preferredColorScheme(.dark)
}

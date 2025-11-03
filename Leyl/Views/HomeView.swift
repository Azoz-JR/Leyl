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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
                .frame(height: 0)
                
                ForEach(0..<100, id: \.self) { num in
                    Text("Number \(num)")
                }
                .frame(maxWidth: .infinity)
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                print("Scroll value: \(value) - topInsets: \(safeAreaInsets.top)")
                scrollOffset = value
                withAnimation(.easeInOut) {
                    hideHeader = scrollOffset < (safeAreaInsets.top + 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Home")
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
}

#Preview {
    HomeView()
        .readSafeAreaInsets()
}

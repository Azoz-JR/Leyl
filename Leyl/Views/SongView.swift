//
//  SongView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import SwiftUI

struct SongView: View {
    
    let namespace: Namespace.ID
    @Binding var showSongView: Bool
    
    @Environment(AudioPlayerManager.self) var audioPlayerManager
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var dragOffset: CGFloat = 0
    @State private var gradientShift = false
    
    @State private var dismissThreshold: CGFloat = 150
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 50, height: 4)
                    .foregroundStyle(Color.white.opacity(0.5))
                    .padding(.top, safeAreaInsets.top)
                
                Image(audioPlayerManager.currentSong?.image ?? "aqareeb")
                    .resizable()
                    .scaledToFill()
                    .frame(width: max(0, geometry.size.width - 40), height: max(0, geometry.size.width - 40))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .scaleEffect(audioPlayerManager.isPlaying ? 1.0 : 0.7)
                    .padding(.top, 30)
                
                VStack(spacing: 0) {
                    Text(audioPlayerManager.currentSong?.title ?? "Khesert Elsha3b")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    
                    Text(audioPlayerManager.currentSong?.artist ?? "Wegz")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.top, 30)
                
                SongPlayerView()
                    .padding(.top, 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                LinearGradient(
                    colors: audioPlayerManager.currentSong?.colors ?? [.black, .black],
                    startPoint: gradientShift ? .topTrailing : .topLeading,
                    endPoint: gradientShift ? .bottomLeading : .bottomTrailing
                )
            }
            .animation(.smooth(duration: 0.4), value: audioPlayerManager.isPlaying)
            .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: gradientShift)
            .clipShape(.rect(cornerRadius: showSongView && dragOffset < 50 ? 0 : 16))
            .ignoresSafeArea()
            .offset(y: showSongView ? dragOffset : 1000)
            .animation(.smooth(duration: 0.4), value: showSongView)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > dismissThreshold {
                            withAnimation(.smooth(duration: 0.4)) {
                                showSongView = false
                            }
                        }
                        withAnimation(.smooth(duration: 0.3)) {
                            dragOffset = 0
                        }
                    }
            )
            .onAppear {
                gradientShift = true
                dismissThreshold = geometry.size.height * 0.4
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var showSongView = true
    
    SongView(namespace: namespace, showSongView: $showSongView)
        .environment(AudioPlayerManager())
}

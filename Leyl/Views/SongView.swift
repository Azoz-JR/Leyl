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
                    .lineLimit(1)
                    .padding(.horizontal, 30)
                    
//                    if showSongView {
//                        MarqueeText(text: audioPlayerManager.currentSong?.title ?? "Khesert Elsha3b", font: .systemFont(ofSize: 21, weight: .bold), leftFade: 2, rightFade: 10, startDelay: 2, alignment: .center)
//                            .padding(.horizontal, 30)
//                            .padding(.bottom, 2)
//                            .id(showSongView)
//                    }
                    
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
                    colors: audioPlayerManager.currentSong?.colors.map { Color(hex: $0) } ?? [.black, .black],
                    startPoint: gradientShift ? .topTrailing : .topLeading,
                    endPoint: gradientShift ? .bottomLeading : .bottomTrailing
                )
            }
            .clipShape(.rect(topLeadingCorner: Edge.Corner.Style(integerLiteral: dragOffset > 0 ? 54 : 0), topTrailingCorner: Edge.Corner.Style(integerLiteral: dragOffset > 0 ? 54 : 0), bottomLeadingCorner: 0, bottomTrailingCorner: 0))
            .ignoresSafeArea()
            .animation(.smooth(duration: 0.4), value: audioPlayerManager.isPlaying)
            .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: gradientShift)
            .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2), value: dragOffset)
            .offset(y: showSongView ? (dragOffset * 0.8) : 1000)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > dismissThreshold {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2)) {
                                showSongView = false
                            }
                        }
                        dragOffset = 0
                    }
            )
            .onAppear {
                gradientShift = true
                dismissThreshold = geometry.size.height * 0.3
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var showSongView = true
    
    SongView(namespace: namespace, showSongView: $showSongView)
        .environment(AudioPlayerManager.preview())
}

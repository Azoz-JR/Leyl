//
//  ScrollingText.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 12/11/25.
//

import SwiftUI

struct ScrollingText: View {
    let text: String
    let font: Font
    let availableWidth: CGFloat
    
    @State private var textWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var animationTask: Task<Void, Never>?
    @State private var needsScrolling = false
    
    private let spacing: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(text)
                .font(font)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .opacity(0)
                .background(
                    GeometryReader { textGeometry in
                        Color.clear
                            .onAppear {
                                let width = textGeometry.size.width
                                textWidth = width
                                needsScrolling = width > availableWidth
                                startScrollingAnimation()
                            }
                            .onChange(of: text) { _, _ in
                                let width = textGeometry.size.width
                                textWidth = width
                                needsScrolling = width > availableWidth
                                resetAnimation()
                            }
                    }
                )
            
            HStack(spacing: spacing) {
                Text(text)
                    .font(font)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                
                if needsScrolling {
                    Text(text)
                        .font(font)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .offset(x: offset)
            .onDisappear {
                animationTask?.cancel()
            }
        }
        .frame(width: availableWidth, alignment: .leading)
        .clipped()
    }
    
    private func resetAnimation() {
        animationTask?.cancel()
        offset = 0
        startScrollingAnimation()
    }
    
    private func startScrollingAnimation() {
        guard needsScrolling else {
            offset = 0
            return
        }
        
        animationTask?.cancel()
        animationTask = Task {
            while !Task.isCancelled {
                offset = 0
                
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { break }
                
                let scrollDistance = textWidth + spacing
                let duration = Double(scrollDistance) / 30.0
                
                withAnimation(.linear(duration: duration)) {
                    offset = -scrollDistance
                }
                
                try? await Task.sleep(for: .seconds(duration))
                guard !Task.isCancelled else { break }
            }
        }
    }
}
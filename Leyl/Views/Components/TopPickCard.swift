//
//  TopPickCard.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct TopPickCard: View {
    let item: TopPickItem
    
    var colors: [Color] {
        if case let .album(_, _, _, colors) = item.type {
            return colors.map{ Color(hex: $0) }
        } else {
            return [.red, .orange]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.category)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 0) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 260)
                
                
                ZStack {
                    LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
                    
                    VStack(spacing: 4) {
                        switch item.type {
                        case .station(let name):
                            Text(name)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                        case .album(let name, let artist, let year, _):
                            Text(name)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                            Text(artist)
                                .font(.system(size: 14))
                                .foregroundStyle(.white.opacity(0.9))
                                .lineLimit(1)
                            
                            Text(year)
                                .font(.system(size: 12))
                                .foregroundStyle(.white.opacity(0.8))
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .frame(height: 80)
            }
            .frame(width: 260, height: 340)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ScrollView(.horizontal) {
        HStack(spacing: 16) {
            TopPickCard(item: TopPickItem(
                category: "Made for you",
                imageName: "leh",
                type: .station(name: "Azoz Salah's Station")
            ))
            
            TopPickCard(item: TopPickItem(
                category: "New Release",
                imageName: "leh",
                type: .album(name: "After Hours", artist: "The Weeknd", year: "2020", colors: ["#000000", "#FFFFFF"])
            ))
        }
        .padding()
    }
}


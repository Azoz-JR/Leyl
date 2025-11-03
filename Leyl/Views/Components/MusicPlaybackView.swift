//
//  MusicPlaybackView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct MusicPlaybackView: View {
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    var body: some View {
        switch placement {
        case .expanded:
            HStack(spacing: 10) {
                Image("leh")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Song name")
                        .font(.system(size: 12))
                    Text("Artist name")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 25)
        default:
            HStack(spacing: 15) {
                Image("leh")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Song name")
                        .font(.system(size: 12))
                    Text("Artist name")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
            .padding(.leading, 20)
            .padding(.trailing, 25)
        }
    }
}

#Preview {
    MusicPlaybackView()
}

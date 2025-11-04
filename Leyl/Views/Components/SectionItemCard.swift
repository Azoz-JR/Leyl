//
//  SectionItemCard.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct SectionItemCard: View {
    let item: SectionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                
                Text(item.subtitle)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 150, alignment: .leading)
        }
        .frame(width: 150)
    }
}

#Preview {
    SectionItemCard(item: SectionItem(
        imageName: "leh",
        title: "Sample Playlist",
        subtitle: "Artist Name"
    ))
    .padding()
}


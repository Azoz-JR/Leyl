//
//  SectionHeader.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let type: SectionType
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.primary)
                        
            if case .tappable = type {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeader(title: "Simple Section", type: .simple)
        SectionHeader(title: "Tappable Section", type: .tappable(destination: { AnyView(Text("Detail")) }))
    }
}


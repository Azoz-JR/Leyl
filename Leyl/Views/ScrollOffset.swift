//
//  ScrollOffset.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 04/11/25.
//

import SwiftUI

struct ScrollOffset: View {
    var body: some View {
        ScrollView {
            ForEach(0..<100) { num in
                VStack {
                    Text("Number \(num)")
                    
                    Text("----------------------------------------------------")
                        .lineLimit(1)
                }
            }
        }
        .onScrollGeometryChange(for: Double.self) { geo in
            geo.contentOffset.y
        } action: { oldValue, newValue in
            print("Height is now \(newValue)")
        }
    }
}

#Preview {
    ScrollOffset()
}

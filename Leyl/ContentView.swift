//
//  ContentView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            MainTabView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.safeAreaInsets, geo.safeAreaInsets)
        }
    }
}

#Preview {
    ContentView()
}

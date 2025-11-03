//
//  SafeAreaInsetsKey.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets = .init()
}


extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

extension View {
    func readSafeAreaInsets() -> some View {
        GeometryReader { geo in
            ZStack {
                self.environment(\.safeAreaInsets, geo.safeAreaInsets)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

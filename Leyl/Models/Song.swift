//
//  Song.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import SwiftUI

struct Song {
    let id = UUID()
    let title: String
    let artist: String
    let image: String?
    let url: URL
    let isLocal: Bool = true
    let colors: [Color]
}

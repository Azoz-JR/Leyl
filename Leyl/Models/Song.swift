//
//  Song.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import SwiftUI

struct Song: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let artist: String
    let image: String?
    let url: URL
    let isLocal: Bool
    let colors: [String]

    init(id: UUID = UUID(), title: String, artist: String, image: String?, url: URL, isLocal: Bool = true, colors: [String] = []) {
        self.id = id
        self.title = title
        self.artist = artist
        self.image = image ?? "aqareeb"
        self.url = url
        self.isLocal = isLocal
        self.colors = colors
    }
}

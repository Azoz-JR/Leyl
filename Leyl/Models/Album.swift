//
//  Album.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 10/11/25.
//

import SwiftUI

struct Album: Identifiable {
    let id: UUID
    let title: String
    let artist: String
    let imageName: String
    let year: String
    let songs: [Song]
    let colors: [String]
    
    init(id: UUID = UUID(), title: String, artist: String, imageName: String, year: String, songs: [Song], colors: [String]) {
        self.id = id
        self.title = title
        self.artist = artist
        self.imageName = imageName
        self.year = year
        self.songs = songs
        self.colors = colors
    }
}


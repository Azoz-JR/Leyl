//
//  SectionItem.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

struct SectionItem: Identifiable, Hashable {
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    let album: Album?
    let song: Song?
    
    init(id: UUID = UUID(), imageName: String, title: String, subtitle: String, album: Album? = nil, song: Song? = nil) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.album = album
        self.song = song
    }
    
    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        lhs.id == rhs.id
    }
}


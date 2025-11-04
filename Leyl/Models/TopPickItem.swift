//
//  TopPickItem.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

enum TopPickType {
    case station(name: String)
    case album(name: String, artist: String, year: String)
}

struct TopPickItem: Identifiable {
    let id: UUID
    let category: String
    let imageName: String
    let type: TopPickType
    
    init(id: UUID = UUID(), category: String, imageName: String, type: TopPickType) {
        self.id = id
        self.category = category
        self.imageName = imageName
        self.type = type
    }
}


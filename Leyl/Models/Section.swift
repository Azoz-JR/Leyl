//
//  Section.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

enum SectionType {
    case simple
    case tappable(destination: () -> AnyView)
}

struct Section: Identifiable {
    let id: UUID
    let title: String
    let type: SectionType
    let items: [SectionItem]
    
    init(id: UUID = UUID(), title: String, type: SectionType, items: [SectionItem]) {
        self.id = id
        self.title = title
        self.type = type
        self.items = items
    }
}


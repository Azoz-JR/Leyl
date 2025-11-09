//
//  PlayingSongAttributes.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 08/11/25.
//

import SwiftUI
import ActivityKit

struct PlayingSongAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
        var currentTime: Double
        var duration: Double
        var isPlaying: Bool
        var title: String
        var artist: String
        var image: String
    }

    // Fixed non-changing properties about your activity go here!
    var song: Song
}

extension PlayingSongAttributes {
    static var preview: PlayingSongAttributes {
        PlayingSongAttributes(
            song: Song(
                title: "Afterparty",
                artist: "Wegz",
                image: "leh",
                url: URL(string: "www.youtube.com")!,
                colors: []
            )
        )
    }
}

extension PlayingSongAttributes.ContentState {
    static var smiley: PlayingSongAttributes.ContentState {
        PlayingSongAttributes.ContentState(
            emoji: "😀",
            currentTime: 42,
            duration: 180,
            isPlaying: true,
            title: "Afterparty",
            artist: "Wegz",
            image: "leh"
        )
     }
     
    static var starEyes: PlayingSongAttributes.ContentState {
         PlayingSongAttributes.ContentState(
            emoji: "🤩",
            currentTime: 120,
            duration: 180,
            isPlaying: false,
            title: "Khesert El Sha3b",
            artist: "Wegz",
            image: "aqareeb"
         )
     }
}

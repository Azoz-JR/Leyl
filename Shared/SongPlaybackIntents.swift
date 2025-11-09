//
//  SongPlaybackIntents.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 09/11/25.
//

import AppIntents

struct TogglePlaybackIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("live_activity_toggle_playback_title")
    static var description: IntentDescription { IntentDescription(LocalizedStringResource("live_activity_toggle_playback_description")) }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AudioPlayerManager.shared.playPause()
        }
        return .result()
    }
}

struct NextSongIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("live_activity_next_song_title")
    static var description: IntentDescription { IntentDescription(LocalizedStringResource("live_activity_next_song_description")) }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AudioPlayerManager.shared.nextTrack()
        }
        return .result()
    }
}

struct PreviousSongIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("live_activity_previous_song_title")
    static var description: IntentDescription { IntentDescription(LocalizedStringResource("live_activity_previous_song_description")) }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AudioPlayerManager.shared.previousTrack()
        }
        return .result()
    }
}

struct SeekSongIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("live_activity_seek_title")
    static var description: IntentDescription { IntentDescription(LocalizedStringResource("live_activity_seek_description")) }
    
    @Parameter(title: LocalizedStringResource("live_activity_seek_time_title"))
    var targetTime: Double
        
    init(targetTime: Double) {
        self.targetTime = targetTime
    }
    
    init() {
        self.targetTime = 0.0
    }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AudioPlayerManager.shared.seek(to: targetTime)
        }
        return .result()
    }
}
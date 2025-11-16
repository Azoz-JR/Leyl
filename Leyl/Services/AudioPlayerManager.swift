//
//  AudioPlayerManager.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import AVFoundation
import Observation
import ActivityKit
import SwiftUI

@MainActor
@Observable
final class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    static func preview() -> AudioPlayerManager {
        AudioPlayerManager()
    }
    
    @ObservationIgnored
    private var player: AVPlayer?
    
    var songs: [Song] = []
    var albums: [Album] = []
    private var currentSongIndex: Int = 0
    var currentSong: Song?
    
    var isPlaying = false
    var isEditing = false
    var currentSongTime: Double = 0.0
    var currentSongDuration: Double = 0.0

    @ObservationIgnored
    private var timeObserverToken: Any?
    
    @ObservationIgnored
    private var activeScrubToken: UUID?
    
    @ObservationIgnored
    private var endTimeObserver: NSObjectProtocol?
    
    private var currentPlayingSongActivity: Activity<PlayingSongAttributes>?
    
    @ObservationIgnored
    private var lastActivityUpdateDate: Date?

    private init() {
        loadSongs()
        setupAlbums()
        setupAudioSession()
        clearLiveActivities()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func loadSongs() {
        guard let url1 = Bundle.main.url(forResource: "Wegz - Khesert El Sha3b", withExtension: "mp3"),
              let url2 = Bundle.main.url(forResource: "Wegz - Afterparty", withExtension: "mp3"),
              let url3 = Bundle.main.url(forResource: "Nasser - Leh", withExtension: "mp3"),
              let url4 = Bundle.main.url(forResource: "Nasser - MEEN FINA", withExtension: "mp3"),
              let url5 = Bundle.main.url(forResource: "Lege-Cy - El Neyya", withExtension: "mp3"),
              let url6 = Bundle.main.url(forResource: "Lege-Cy - LAW NASYANY", withExtension: "mp3"),
              let url7 = Bundle.main.url(forResource: "Dua Lipa - Houdini", withExtension: "mp3"),
              let url8 = Bundle.main.url(forResource: "Dua Lipa - Fever", withExtension: "mp3") else {
            print("Failed to load songs")
            return
        }
        
        let song1 = Song(title: "Khesert El Sha3b", artist: "Wegz", image: "aqareeb", url: url1, colors: ["#A68563", "#A68563"])
        let song2 = Song(title: "Afterparty", artist: "Wegz", image: "aqareeb", url: url2, colors: ["#A68563", "#A68563"])
        let song3 = Song(title: "Leh", artist: "Nasser", image: "leh", url: url3, colors: ["#2C3F43", "#7D8987"])
        let song4 = Song(title: "MEEN FINA", artist: "Nasser", image: "leh", url: url4, colors: ["#2C3F43", "#7D8987"])
        let song5 = Song(title: "El Neyya", artist: "Lege-Cy", image: "lege-cy", url: url5, colors: ["#2C3F43", "#7D8987"])
        let song6 = Song(title: "LAW NASYANY", artist: "Lege-Cy", image: "lege-cy", url: url6, colors: ["#2C3F43", "#7D8987"])
        let song7 = Song(title: "Houdini", artist: "Dua Lipa", image: "dua-lipa", url: url7, colors: ["#2C3F43", "#7D8987"])
        let song8 = Song(title: "Fever", artist: "Dua Lipa", image: "dua-lipa", url: url8, colors: ["#2C3F43", "#7D8987"])

        songs = [song1, song2, song3, song4, song5, song6, song7, song8]
        
        if !songs.isEmpty {
            currentSong = songs[0]
        }
    }
    
    private func setupAlbums() {
        let wegzSongs = songs.filter { $0.artist == "Wegz" }
        let nasserSongs = songs.filter { $0.artist == "Nasser" }
        let legeCySongs = songs.filter { $0.artist == "Lege-Cy" }
        let duaLipaSongs = songs.filter { $0.artist == "Dua Lipa" }

        if !wegzSongs.isEmpty {
            let wegzAlbum = Album(
                title: "Aqareeb",
                artist: "Wegz",
                imageName: "aqareeb",
                year: "2024",
                songs: wegzSongs,
                colors: ["#A68563", "#A68563"]
            )
            albums.append(wegzAlbum)
        }
        
        if !nasserSongs.isEmpty {
            let nasserAlbum = Album(
                title: "Leh",
                artist: "Nasser",
                imageName: "leh",
                year: "2024",
                songs: nasserSongs,
                colors: ["#2C3F43", "#7D8987"]
            )
            albums.append(nasserAlbum)
        }

        if !legeCySongs.isEmpty {
            let legeCyAlbum = Album(
                title: "Swissra",
                artist: "Lege-Cy",
                imageName: "lege-cy",
                year: "2024",
                songs: legeCySongs,
                colors: ["#2C3F43", "#7D8987"]
            )
            albums.append(legeCyAlbum)
        }

        if !duaLipaSongs.isEmpty {
            let duaLipaAlbum = Album(
                title: "Radical Optimism",
                artist: "Dua Lipa",
                imageName: "dua-lipa",
                year: "2023",
                songs: duaLipaSongs,
                colors: ["#2C3F43", "#7D8987"]
            )
            albums.append(duaLipaAlbum)
        }
    }
    
    private func setupPlayer(for song: Song) {
        removeTimeObserver()
        removeEndTimeObserver()
        
        let playerItem = AVPlayerItem(url: song.url)
        player = AVPlayer(playerItem: playerItem)
        
        currentSong = song
        currentSongTime = 0.0
        
        let duration = playerItem.duration.seconds
        if duration.isFinite {
            currentSongDuration = duration
        } else {
            currentSongDuration = 0.0
        }
        
        addTimeObserver()
        addEndTimeObserver()
        updateLiveActivityIfNeeded(force: true)
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.handlePeriodicTimeUpdate(time)
            }
        }
    }
    
    private func addEndTimeObserver() {
        endTimeObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.handleSongFinished()
            }
        }
    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    private func removeEndTimeObserver() {
        if let observer = endTimeObserver {
            NotificationCenter.default.removeObserver(observer)
            endTimeObserver = nil
        }
    }
    
    private func handleSongFinished() {
        nextTrack()
    }
    
    func playSong(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            currentSongIndex = index
        }
        
        setupPlayer(for: song)
        player?.play()
        isPlaying = true
        
        if currentPlayingSongActivity == nil {
            startPlayingSongActivity()
        } else {
            updateLiveActivityIfNeeded(force: true)
        }
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
            isPlaying = false
            updateLiveActivityIfNeeded(force: true)
        } else {
            if player == nil, let song = currentSong {
                setupPlayer(for: song)
            }
            player?.play()
            isPlaying = true
            
            if currentPlayingSongActivity == nil {
                startPlayingSongActivity()
            } else {
                updateLiveActivityIfNeeded(force: true)
            }
        }
    }
    
    func nextTrack() {
        guard !songs.isEmpty else { return }
        currentSongIndex = (currentSongIndex + 1) % songs.count
        let nextSong = songs[currentSongIndex]
        
        setupPlayer(for: nextSong)
        player?.play()
        isPlaying = true
        
        if currentPlayingSongActivity == nil {
            startPlayingSongActivity()
        } else {
            updateLiveActivityIfNeeded(force: true)
        }
    }
    
    func previousTrack() {
        guard !songs.isEmpty else { return }
        
        if currentSongTime > 2.0 {
            player?.seek(to: .zero)
            currentSongTime = 0.0
            updateLiveActivityIfNeeded(force: true)
        } else {
            currentSongIndex = (currentSongIndex - 1 + songs.count) % songs.count
            let previousSong = songs[currentSongIndex]
            
            setupPlayer(for: previousSong)
            player?.play()
            isPlaying = true
            
            if currentPlayingSongActivity == nil {
                startPlayingSongActivity()
            } else {
                updateLiveActivityIfNeeded(force: true)
            }
        }
    }
    
    func beginScrubbing() {
        isEditing = true
        activeScrubToken = nil
    }
    
    func completeScrubbing(at time: Double) {
        currentSongTime = time
        guard let player else {
            isEditing = false
            activeScrubToken = nil
            updateLiveActivityIfNeeded(force: true)
            return
        }
        let targetTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let token = UUID()
        activeScrubToken = token
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            guard finished else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self, self.activeScrubToken == token else { return }
                self.currentSongTime = time
                self.isEditing = false
                self.activeScrubToken = nil
                self.updateLiveActivityIfNeeded(force: true)
            }
        }
    }
    
    func seek(to time: Double) {
        guard let player else {
            currentSongTime = time
            updateLiveActivityIfNeeded(force: true)
            return
        }
        activeScrubToken = nil
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentSongTime = time
        updateLiveActivityIfNeeded(force: true)
    }
    
    func stop() {
        player?.pause()
        removeTimeObserver()
        removeEndTimeObserver()
        player = nil
        isPlaying = false
        currentSongTime = 0.0
        isEditing = false
        activeScrubToken = nil
        currentSongDuration = 0.0
        
        if currentPlayingSongActivity != nil {
            endPlayingSongActivity()
        } else {
            updateLiveActivityIfNeeded(force: true)
        }
    }
    
    func startPlayingSongActivity() {
        guard currentPlayingSongActivity == nil else {
            updateLiveActivityIfNeeded(force: true)
            return
        }
        guard let currentSong else { return }
        
        let attributes = PlayingSongAttributes(song: currentSong)
        let content = ActivityContent(state: makeContentState(), staleDate: Date.now.addingTimeInterval(1.0))
        
        do {
            let activity = try Activity<PlayingSongAttributes>.request(attributes: attributes, content: content, pushType: nil)
            currentPlayingSongActivity = activity
            lastActivityUpdateDate = Date()
        } catch {
            print("Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    func endPlayingSongActivity() {
        print("endPlayingSongActivity: \(currentPlayingSongActivity)")
        guard let currentPlayingSongActivity else { return }
        let finalContent = ActivityContent(state: makeContentState(), staleDate: Date.now.addingTimeInterval(1.0))
        
        Task {
            print("endPlayingSongActivity will start")
            await currentPlayingSongActivity.end(finalContent, dismissalPolicy: .immediate)
            print("endPlayingSongActivity done")
            self.currentPlayingSongActivity = nil
            self.lastActivityUpdateDate = nil
        }
    }

    private func handlePeriodicTimeUpdate(_ time: CMTime) {
        if !isEditing {
            currentSongTime = time.seconds
        }
        
        if let duration = player?.currentItem?.duration.seconds, duration.isFinite {
            currentSongDuration = duration
        }
        
        if currentPlayingSongActivity != nil, isPlaying, !isEditing {
            updateLiveActivityIfNeeded()
        }
    }
    
    private func makeContentState() -> PlayingSongAttributes.ContentState {
        let song = currentSong
        return PlayingSongAttributes.ContentState(
            emoji: activityEmoji,
            currentTime: currentSongTime,
            duration: currentSongDuration,
            isPlaying: isPlaying,
            title: song?.title ?? "",
            artist: song?.artist ?? "",
            image: (song?.image ?? "leh").appending("-DI")
        )
    }
    
    private var activityEmoji: String {
        isPlaying ? "🎧" : "⏸️"
    }
    
    private func updateLiveActivityIfNeeded(force: Bool = false) {
        guard let activity = currentPlayingSongActivity else { return }
        
        let now = Date()
        if !force,
           let lastActivityUpdateDate,
           now.timeIntervalSince(lastActivityUpdateDate) < 1.0 {
            return
        }
        
        lastActivityUpdateDate = now
        let state = makeContentState()
        
        Task {
            await activity.update(ActivityContent(state: state, staleDate: Date.now.addingTimeInterval(1.0)))
        }
    }
    
    func clearLiveActivities() {
        Task {
            for activity in Activity<PlayingSongAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
    func endAllLiveActivities() {
        print("Ending Live Activities")
        let semaphore = DispatchSemaphore(value: 0)
        Task
        {
            for activity in Activity<PlayingSongAttributes>.activities
            {
                print("Ending Live Activity: \(activity.id)")
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    @MainActor deinit {
        removeTimeObserver()
        removeEndTimeObserver()
    }
}

//
//  AudioPlayerManager.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import AVFoundation
import Observation
import SwiftUI

@Observable
class AudioPlayerManager {
    @ObservationIgnored
    private var player: AVPlayer?
    
    var songs: [Song] = []
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

    init() {
        loadSongs()
        setupAudioSession()
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
              let url4 = Bundle.main.url(forResource: "Nasser - MEEN FINA", withExtension: "mp3") else {
            print("Failed to load songs")
            return
        }
        
        let song1 = Song(title: "Khesert El Sha3b", artist: "Wegz", image: "aqareeb", url: url1, colors: [Color(hex: "#A68563"), Color(hex: "#A68563")])
        let song2 = Song(title: "Afterparty", artist: "Wegz", image: "aqareeb", url: url2, colors: [Color(hex: "#A68563"), Color(hex: "#A68563")])
        let song3 = Song(title: "Leh", artist: "Nasser", image: "leh", url: url3, colors: [Color(hex: "#2C3F43"), Color(hex: "#7D8987")])
        let song4 = Song(title: "MEEN FINA", artist: "Nasser", image: "leh", url: url4, colors: [Color(hex: "#2C3F43"), Color(hex: "#7D8987")])

        songs = [song1, song2, song3, song4]
        
        if !songs.isEmpty {
            currentSong = songs[0]
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
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            if !self.isEditing {
                self.currentSongTime = time.seconds
            }
            
            if let duration = self.player?.currentItem?.duration.seconds, duration.isFinite {
                self.currentSongDuration = duration
            }
        }
    }
    
    private func addEndTimeObserver() {
        endTimeObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.handleSongFinished()
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
    
    func play(song: Song) {
        guard let index = songs.firstIndex(where: { $0.id == song.id }) else { return }
        
        currentSongIndex = index
        setupPlayer(for: song)
        
        player?.play()
        isPlaying = true
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            if player == nil, let song = currentSong {
                setupPlayer(for: song)
            }
            player?.play()
            isPlaying = true
        }
    }
    
    func nextTrack() {
        currentSongIndex = (currentSongIndex + 1) % songs.count
        let nextSong = songs[currentSongIndex]
        
//        let wasPlaying = isPlaying
        setupPlayer(for: nextSong)
        
//        if wasPlaying {
            player?.play()
            isPlaying = true
//        }
    }
    
    func previousTrack() {
        if currentSongTime > 2.0 {
            player?.seek(to: .zero)
            currentSongTime = 0.0
        } else {
            currentSongIndex = (currentSongIndex - 1 + songs.count) % songs.count
            let previousSong = songs[currentSongIndex]
            
//            let wasPlaying = isPlaying
            setupPlayer(for: previousSong)
            
//            if wasPlaying {
                player?.play()
                isPlaying = true
//            }
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
            }
        }
    }
    
    func seek(to time: Double) {
        guard let player else {
            currentSongTime = time
            return
        }
        activeScrubToken = nil
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentSongTime = time
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
    }
    
    deinit {
        removeTimeObserver()
        removeEndTimeObserver()
    }
}

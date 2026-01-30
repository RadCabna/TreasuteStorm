import Foundation
import AVFoundation
import UIKit

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var settings = SettingsManager.shared
    
    private init() {
        setupAudio()
        setupObservers()
    }
    
    private func setupAudio() {
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
        
        guard let url = Bundle.main.url(forResource: "musicMain", withExtension: "mp3") else {
            print("Audio file not found: musicMain.mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Infinite loop (-1 means loop forever)
            audioPlayer?.prepareToPlay()
            
            // Set initial volume
            audioPlayer?.volume = Float(settings.volumeLevel)
            
            // Don't start playing by default (music is off by default)
            if settings.isMusicOn {
                audioPlayer?.play()
            }
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    private func setupObservers() {
        // Observe music on/off changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMusicToggle),
            name: NSNotification.Name("MusicToggled"),
            object: nil
        )
        
        // Observe volume changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleVolumeChange),
            name: NSNotification.Name("VolumeChanged"),
            object: nil
        )
        
        // Observe app lifecycle events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func handleMusicToggle() {
        if settings.isMusicOn {
            play()
        } else {
            pause()
        }
    }
    
    @objc private func handleVolumeChange() {
        audioPlayer?.volume = Float(settings.volumeLevel)
    }
    
    @objc private func handleAppWillResignActive() {
        // Keep music playing when app goes to background if music is on
        if !settings.isMusicOn {
            pause()
        }
    }
    
    @objc private func handleAppDidBecomeActive() {
        // Resume music if it should be playing
        if settings.isMusicOn && audioPlayer?.isPlaying == false {
            play()
        }
    }
    
    func play() {
        guard settings.isMusicOn else { return }
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    func updateVolume(_ volume: Double) {
        audioPlayer?.volume = Float(volume)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

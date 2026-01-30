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
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {}
        
        guard let url = Bundle.main.url(forResource: "musicMain", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = Float(settings.volumeLevel)
            
            if settings.isMusicOn {
                audioPlayer?.play()
            }
        } catch {}
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMusicToggle),
            name: NSNotification.Name("MusicToggled"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleVolumeChange),
            name: NSNotification.Name("VolumeChanged"),
            object: nil
        )
        
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
        if !settings.isMusicOn {
            pause()
        }
    }
    
    @objc private func handleAppDidBecomeActive() {
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

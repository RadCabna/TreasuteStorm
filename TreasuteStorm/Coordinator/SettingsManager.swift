import Foundation

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            NotificationCenter.default.post(name: NSNotification.Name("MusicToggled"), object: nil)
        }
    }
    
    @Published var volumeLevel: Double {
        didSet {
            UserDefaults.standard.set(volumeLevel, forKey: "volumeLevel")
            NotificationCenter.default.post(name: NSNotification.Name("VolumeChanged"), object: nil)
        }
    }
    
    private init() {
        // Music is off by default
        self.isMusicOn = UserDefaults.standard.object(forKey: "isMusicOn") as? Bool ?? false
        self.volumeLevel = UserDefaults.standard.object(forKey: "volumeLevel") as? Double ?? 0.7
    }
}

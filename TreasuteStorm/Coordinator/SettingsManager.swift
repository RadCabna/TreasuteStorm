import Foundation

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
        }
    }
    
    @Published var volumeLevel: Double {
        didSet {
            UserDefaults.standard.set(volumeLevel, forKey: "volumeLevel")
        }
    }
    
    private init() {
        self.isMusicOn = UserDefaults.standard.object(forKey: "isMusicOn") as? Bool ?? true
        self.volumeLevel = UserDefaults.standard.object(forKey: "volumeLevel") as? Double ?? 0.7
    }
}

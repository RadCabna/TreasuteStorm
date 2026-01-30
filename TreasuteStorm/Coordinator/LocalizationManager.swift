import Foundation

enum Language: String, CaseIterable {
    case english = "English"
    case german = "Deutsch"
    case spanish = "Español"
    case french = "Français"
}

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .english
        }
    }
    
    func localized(_ key: String) -> String {
        switch currentLanguage {
        case .english:
            return translations[key]?["en"] ?? key
        case .german:
            return translations[key]?["de"] ?? key
        case .spanish:
            return translations[key]?["es"] ?? key
        case .french:
            return translations[key]?["fr"] ?? key
        }
    }
    
    private let translations: [String: [String: String]] = [
        // Settings
        "Music": [
            "en": "Music",
            "de": "Musik",
            "es": "Música",
            "fr": "Musique"
        ],
        "Volume": [
            "en": "Volume",
            "de": "Lautstärke",
            "es": "Volumen",
            "fr": "Volume"
        ],
        "Language": [
            "en": "Language",
            "de": "Sprache",
            "es": "Idioma",
            "fr": "Langue"
        ],
        
        // Game
        "Moves": [
            "en": "Moves",
            "de": "Züge",
            "es": "Movimientos",
            "fr": "Mouvements"
        ],
        "Level": [
            "en": "Level",
            "de": "Level",
            "es": "Nivel",
            "fr": "Niveau"
        ],
        
        // Shop
        "BUY": [
            "en": "BUY",
            "de": "KAUFEN",
            "es": "COMPRAR",
            "fr": "ACHETER"
        ],
        "Select": [
            "en": "Select",
            "de": "Wählen",
            "es": "Seleccionar",
            "fr": "Sélectionner"
        ],
        "Selected": [
            "en": "Selected",
            "de": "Ausgewählt",
            "es": "Seleccionado",
            "fr": "Sélectionné"
        ],
        
        // Daily Tasks
        "Complete one level": [
            "en": "Complete one level",
            "de": "Schließe ein Level ab",
            "es": "Completa un nivel",
            "fr": "Complétez un niveau"
        ],
        "Defeat 10 opponents": [
            "en": "Defeat 10 opponents",
            "de": "Besiege 10 Gegner",
            "es": "Derrota a 10 oponentes",
            "fr": "Battez 10 adversaires"
        ]
    ]
}

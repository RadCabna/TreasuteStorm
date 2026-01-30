import Foundation

enum AvailableScreens: Equatable {
    case LOADING
    case ONBOARDING
    case MAIN
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    @Published var coins: Int = 0
    @Published var completedLevels: Set<Int> = []
    @Published var selectedSkin: Int = 6  // Default skin (full set)
    static var shared: NavGuard = .init()
    
    init() {
        // Reset coins and progress
        coins = 0
        completedLevels = []
        UserDefaults.standard.set(0, forKey: "coins")
        UserDefaults.standard.set([], forKey: "completedLevels")
        
        selectedSkin = UserDefaults.standard.integer(forKey: "selectedSkin")
        if selectedSkin == 0 {
            selectedSkin = 6  // Default to full set
            saveSkin()
        }
        
        // Initialize purchasedSkins with default skin (6) if not set
        var purchased = UserDefaults.standard.array(forKey: "purchasedSkins") as? [Int]
        if purchased == nil {
            purchased = [6]
            UserDefaults.standard.set(purchased, forKey: "purchasedSkins")
        }
    }
    
    func saveCoins() {
        UserDefaults.standard.set(coins, forKey: "coins")
    }
    
    func saveSkin() {
        UserDefaults.standard.set(selectedSkin, forKey: "selectedSkin")
    }
    
    func isLevelCompleted(_ levelNumber: Int) -> Bool {
        return completedLevels.contains(levelNumber)
    }
    
    func isLevelUnlocked(_ levelNumber: Int) -> Bool {
        if levelNumber == 1 {
            return true  // First level always unlocked
        }
        return completedLevels.contains(levelNumber - 1)  // Level unlocked if previous completed
    }
    
    func completeLevel(_ levelNumber: Int) -> Bool {
        let isFirstCompletion = !completedLevels.contains(levelNumber)
        completedLevels.insert(levelNumber)
        UserDefaults.standard.set(Array(completedLevels), forKey: "completedLevels")
        
        if isFirstCompletion {
            coins += 50
            saveCoins()
        }
        
        return isFirstCompletion
    }
    
    // Get player image based on selected skin
    func getPlayerImage() -> String {
        if selectedSkin == 6 {
            return "player_6"
        } else {
            return "itemShop_\(selectedSkin)"
        }
    }
    
    // Get enemy image based on selected skin
    func getEnemyImage() -> String {
        return selectedSkin == 6 ? "enemy_1" : "enemy_2"
    }
    
    // Get sticky cell image based on selected skin
    func getStickyImage() -> String {
        return selectedSkin == 6 ? "stikyCell_1" : "stikyCell_2"
    }
    
    // Get teleport images based on selected skin and color (1, 2, or 3)
    func getTeleportImage(color: Int) -> String {
        if selectedSkin == 6 {
            return "teleport1_\(color)"
        } else {
            return "teleport2_\(color)"
        }
    }
}

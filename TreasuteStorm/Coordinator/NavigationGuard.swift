import Foundation

enum AvailableScreens: Equatable {
    case LOADING
    case ONBOARDING
    case MAIN
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    @Published var coins: Int = 0
    static var shared: NavGuard = .init()
    
    init() {
        coins = UserDefaults.standard.integer(forKey: "coins")
    }
    
    func saveCoins() {
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}

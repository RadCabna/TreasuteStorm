import SwiftUI

enum ShopItemStatus {
    case notPurchased
    case bought
    case selected
}

struct ShopItem {
    let id: Int
    let imageName: String
    let price: Int
    var status: ShopItemStatus
}

// MARK: - Shop Content
struct ShopContent: View {
    @Binding var currentMenu: MenuState
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var currentItemIndex: Int = 0
    @State private var slideDirection: CGFloat = 0
    @State private var shopItems: [ShopItem] = []
    
    var currentItem: ShopItem {
        guard !shopItems.isEmpty && currentItemIndex < shopItems.count else {
            return ShopItem(id: 1, imageName: "itemShop_1", price: 100, status: .notPurchased)
        }
        return shopItems[currentItemIndex]
    }
    
    var body: some View {
        ZStack {
            // Shop item frame in center
            Image("shopItemFrame")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.25)
                .padding(screenWidth*0.0265)
            
            // Item with slide animation
            ZStack {
                Image(currentItem.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: currentItem.id == 6 ? screenWidth * 0.15 : screenWidth * 0.1)
                    .offset(x: slideDirection)
            }
            .frame(width: screenWidth * 0.25)
            .clipped()
            
            // Left arrow
            HStack {
                Button(action: {
                    previousItem()
                }) {
                    Image("shopArrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.04)
                }
                .offset(x: -screenWidth * 0.16)
            }
            
            // Right arrow (mirrored)
            HStack {
                Button(action: {
                    nextItem()
                }) {
                    Image("shopArrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.04)
                        .scaleEffect(x: -1, y: 1)
                }
                .offset(x: screenWidth * 0.16)
            }
            
            // Price frame (top right corner, outside frame)
            VStack {
                HStack {
                    
                    ZStack {
                        Image("countFrame")
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenWidth * 0.06)
                        
                        Text("\(currentItem.price)")
                            .font(.custom("JosefinSans-Bold", size: screenWidth * 0.026))
                            .foregroundColor(.white)
                            .padding(.trailing, screenWidth * 0.03)
                    }
                    .offset(x: screenWidth * 0.11, y: -screenWidth * 0.12)
                }
                
            }
            
            // Status button (bottom, half outside)
            VStack {
                
                
                Button(action: {
                    handleButtonAction()
                }) {
                    ZStack {
                        Image("gameRect")
                            .resizable()
                            .frame(width: screenWidth * 0.15, height: screenWidth * 0.04)
                        
                        Text(buttonText)
                            .font(.custom("JosefinSans-Bold", size: screenWidth * 0.022))
                            .foregroundColor(.white)
                            .offset(y: screenWidth*0.005)
                    }
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
                .offset(y: screenWidth * 0.12)
            }
        }
        .onAppear {
            if shopItems.isEmpty {
                loadShopItems()
            }
        }
    }
    
    func loadShopItems() {
        // Initialize shop items with saved status
        let purchased = UserDefaults.standard.array(forKey: "purchasedSkins") as? [Int] ?? [6]  // Item 6 is default
        let selected = UserDefaults.standard.integer(forKey: "selectedSkin")
        let selectedSkin = selected == 0 ? 6 : selected
        
        var items: [ShopItem] = []
        for i in 1...6 {
            let price = i == 6 ? 200 : 100
            var status: ShopItemStatus = .notPurchased
            
            if purchased.contains(i) {
                status = i == selectedSkin ? .selected : .bought
            }
            
            items.append(ShopItem(id: i, imageName: "itemShop_\(i)", price: price, status: status))
        }
        
        shopItems = items
    }
    
    var buttonText: String {
        let localization = LocalizationManager.shared
        switch currentItem.status {
        case .notPurchased:
            return localization.localized("BUY")
        case .bought:
            return localization.localized("Select")
        case .selected:
            return localization.localized("Selected")
        }
    }
    
    var isButtonDisabled: Bool {
        if currentItem.status == .selected {
            return true
        }
        if currentItem.status == .notPurchased && nav.coins < currentItem.price {
            return true
        }
        return false
    }
    
    func handleButtonAction() {
        guard !shopItems.isEmpty && currentItemIndex < shopItems.count else { return }
        
        switch currentItem.status {
        case .notPurchased:
            if nav.coins >= currentItem.price {
                nav.coins -= currentItem.price
                nav.saveCoins()
                shopItems[currentItemIndex].status = .bought
                
                // Save purchased skins
                var purchased = UserDefaults.standard.array(forKey: "purchasedSkins") as? [Int] ?? []
                if !purchased.contains(currentItem.id) {
                    purchased.append(currentItem.id)
                    UserDefaults.standard.set(purchased, forKey: "purchasedSkins")
                }
            }
        case .bought:
            // Deselect previous selection
            for i in 0..<shopItems.count {
                if shopItems[i].status == .selected {
                    shopItems[i].status = .bought
                }
            }
            
            // Select current item
            shopItems[currentItemIndex].status = .selected
            
            // Save to NavigationGuard
            nav.selectedSkin = currentItem.id
            nav.saveSkin()
        case .selected:
            break
        }
    }
    
    func nextItem() {
        guard !shopItems.isEmpty else { return }
        let nextIndex = (currentItemIndex + 1) % shopItems.count
        
        withAnimation(.easeInOut(duration: 0.3)) {
            slideDirection = -screenWidth * 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentItemIndex = nextIndex
            slideDirection = screenWidth * 0.3
            
            withAnimation(.easeInOut(duration: 0.15)) {
                slideDirection = 0
            }
        }
    }
    
    func previousItem() {
        guard !shopItems.isEmpty else { return }
        let prevIndex = (currentItemIndex - 1 + shopItems.count) % shopItems.count
        
        withAnimation(.easeInOut(duration: 0.3)) {
            slideDirection = screenWidth * 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentItemIndex = prevIndex
            slideDirection = -screenWidth * 0.3
            
            withAnimation(.easeInOut(duration: 0.15)) {
                slideDirection = 0
            }
        }
    }
}

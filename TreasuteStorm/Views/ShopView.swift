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
    @State private var shopItems: [ShopItem] = [
        ShopItem(id: 1, imageName: "itemShop_1", price: 100, status: .notPurchased),
        ShopItem(id: 2, imageName: "itemShop_2", price: 100, status: .notPurchased),
        ShopItem(id: 3, imageName: "itemShop_3", price: 100, status: .notPurchased),
        ShopItem(id: 4, imageName: "itemShop_4", price: 100, status: .notPurchased),
        ShopItem(id: 5, imageName: "itemShop_5", price: 100, status: .notPurchased),
        ShopItem(id: 6, imageName: "itemShop_6", price: 200, status: .notPurchased)
    ]
    
    var currentItem: ShopItem {
        shopItems[currentItemIndex]
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
    }
    
    var buttonText: String {
        switch currentItem.status {
        case .notPurchased:
            return "BUY"
        case .bought:
            return "Select"
        case .selected:
            return "Selected"
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
        switch currentItem.status {
        case .notPurchased:
            if nav.coins >= currentItem.price {
                nav.coins -= currentItem.price
                nav.saveCoins()
                shopItems[currentItemIndex].status = .bought
            }
        case .bought:
            for i in 0..<shopItems.count {
                if shopItems[i].status == .selected {
                    shopItems[i].status = .bought
                }
            }
            shopItems[currentItemIndex].status = .selected
        case .selected:
            break
        }
    }
    
    func nextItem() {
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

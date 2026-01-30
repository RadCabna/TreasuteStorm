import SwiftUI

struct Main: View {
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var currentMenu: MenuState = .game
    @State private var selectedLevel: Int = 1
    
    var body: some View {
        ZStack {
            if currentMenu == .playing {
                // Full screen game view
                GameScreen(currentMenu: $currentMenu, selectedLevel: $selectedLevel)
                    .transition(.opacity)
            } else {
                // Main menu with central block
                ZStack {
                    Color("gameColor_1")
                        .ignoresSafeArea()
                    
                    TopBar()
                        .ignoresSafeArea()
                        .frame(maxHeight: .infinity, alignment: .top)
                    
                    CentralGameBlock(currentMenu: $currentMenu, selectedLevel: $selectedLevel)
                        .offset(y: screenWidth * 0.01)
                    
                    // Arrow back button positioned separately
                    if currentMenu == .settings || currentMenu == .shop || currentMenu == .achievements || currentMenu == .dailyTasks || currentMenu == .levelSelection {
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentMenu = .game
                                }
                            }) {
                                Image("arrowBack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth * 0.04)
                            }
                            .offset(x: screenWidth * 0.155, y: screenWidth * 0.195)
                            
                            Spacer()
                        }
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

struct TopBar: View {
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    
    var body: some View {
        ZStack {
            Color("gameColor_2")
                .frame(height: screenWidth * 0.08)
            
            HStack {
                Image("gameNameText")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenWidth * 0.04)
                    .padding(.leading, screenWidth * 0.03)
                
                Spacer()
                    .frame(width: screenWidth*0.65)
                
                ZStack(alignment: .leading) {
                    Image("countFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenWidth * 0.06)
                    
                    Text("\(nav.coins)")
                        .font(.custom("JosefinSans-Bold", size: screenWidth * 0.03))
                        .foregroundColor(.white)
                        .padding(.leading, screenWidth * 0.003)
                }
                .padding(.trailing, screenWidth * 0.03)
            }
            .offset(y:screenWidth*0.01)
        }
    }
}

struct CentralGameBlock: View {
    @Binding var currentMenu: MenuState
    @Binding var selectedLevel: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: screenWidth * 0.015)
                .fill(Color.white.opacity(0.95))
                .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
            
            VStack(spacing: screenWidth * 0.0) {
                VStack(spacing: screenWidth*0.005) {
                    MenuIcons(currentMenu: $currentMenu)
                    
                    Rectangle()
                        .fill(Color("gameColor_1"))
                        .frame(width: screenWidth * 0.4, height: screenWidth*0.006)
                }
                .offset(y: -screenWidth*0.015)
                
                if currentMenu == .game {
                    GameField(currentMenu: $currentMenu)
                        .transition(.opacity)
                } else if currentMenu == .settings {
                    SettingsContent(currentMenu: $currentMenu)
                        .transition(.opacity)
                } else if currentMenu == .shop {
                    ShopContent(currentMenu: $currentMenu)
                        .transition(.opacity)
                } else if currentMenu == .achievements {
                    AchievementsContent(currentMenu: $currentMenu)
                        .transition(.opacity)
                } else if currentMenu == .dailyTasks {
                    DailyTaskContent(currentMenu: $currentMenu)
                        .transition(.opacity)
                } else if currentMenu == .levelSelection {
                    LevelSelectionContent(currentMenu: $currentMenu, selectedLevel: $selectedLevel)
                        .transition(.opacity)
                }
            }
        }
    }
}

struct MenuIcons: View {
    @Binding var currentMenu: MenuState
    
    var body: some View {
        HStack(spacing: screenWidth * 0.01) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentMenu = .settings
                }
            }) {
                Image("settingsIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.04)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentMenu = .dailyTasks
                }
            }) {
                Image("tasksIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.04)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentMenu = .achievements
                }
            }) {
                Image("achievementsIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.04)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentMenu = .shop
                }
            }) {
                Image("shopIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.04)
            }
        }
        .padding(.top, screenWidth * 0.01)
    }
}

struct GameField: View {
    @Binding var currentMenu: MenuState
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("menuFrame")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.3)
            
            ZStack() {
                MainMenuGrid(currentMenu: $currentMenu)
                
                VStack {
                    HStack(alignment: .bottom) {
                        Image("menuPers_1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.07)
                        
                        Spacer()
                            .frame(width: screenWidth*0.14)
                        
                        Image("menuPers_2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.07)
                    }
                }
                .offset(y: screenWidth * 0.09)
            }
        }
    }
}

struct MainMenuGrid: View {
    @Binding var currentMenu: MenuState
    let rows = 7
    let columns = 8
    
    var body: some View {
        ZStack {
            VStack(spacing: screenWidth * 0.005) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: screenWidth * 0.001) {
                        ForEach(0..<columns, id: \.self) { column in
                            MainMenuCellView(row: row, column: column)
                        }
                    }
                }
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentMenu = .levelSelection
                }
            }) {
                Image("playButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.15)
            }
            .offset(y: -screenWidth * 0.07)
        }
    }
}

struct MainMenuCellView: View {
    let row: Int
    let column: Int
    
    var isSpecialCell: Bool {
        return row == 3 && column >= 1 && column <= 6
    }
    
    var body: some View {
        ZStack {
            if isSpecialCell {
                Image("gameRectOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.035, height: screenWidth * 0.04)
                    .opacity(0.3)
            } else {
                Image("gameRect")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.035, height: screenWidth * 0.04)
                    .opacity(0.3)
            }
        }
    }
}

#Preview {
    Main()
}

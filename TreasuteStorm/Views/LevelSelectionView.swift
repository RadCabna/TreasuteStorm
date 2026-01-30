import SwiftUI

enum LevelStatus {
    case locked
    case unlocked
}

struct Level {
    let number: Int
    var status: LevelStatus
}

// MARK: - Level Selection Content
struct LevelSelectionContent: View {
    @Binding var currentMenu: MenuState
    @Binding var selectedLevel: Int
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var levels: [Level] = []
    
    init(currentMenu: Binding<MenuState>, selectedLevel: Binding<Int>) {
        self._currentMenu = currentMenu
        self._selectedLevel = selectedLevel
        
        // Initialize levels based on completion status
        var levelArray: [Level] = []
        for i in 1...15 {
            let status: LevelStatus = NavGuard.shared.isLevelUnlocked(i) ? .unlocked : .locked
            levelArray.append(Level(number: i, status: status))
        }
        _levels = State(initialValue: levelArray)
    }
    
    var body: some View {
        ZStack {
            
            // Levels grid (3 rows, 5 columns)
            VStack(spacing: screenWidth * 0.01) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: screenWidth * 0.01) {
                        ForEach(0..<5, id: \.self) { col in
                            let levelIndex = row * 5 + col
                            if levelIndex < levels.count {
                                let level = levels[levelIndex]
                                
                                LevelCell(
                                    level: level,
                                    isSelected: selectedLevel == level.number,
                                    onTap: {
                                        if level.status == .unlocked {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                selectedLevel = level.number
                                            }
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .padding(screenWidth*0.055)
            .offset(y: -screenWidth*0.02)
            
            // Play button (bottom, half outside)
            VStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentMenu = .playing
                    }
                }) {
                    Image("playButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.15)
                }
                .offset(y: screenWidth * 0.135)
            }
        }
        .onAppear {
            updateLevels()
            // Auto-select first incomplete level
            if selectedLevel == 0 || !nav.isLevelUnlocked(selectedLevel) {
                for level in levels {
                    if level.status == .unlocked && !nav.isLevelCompleted(level.number) {
                        selectedLevel = level.number
                        break
                    }
                }
                // If all levels completed, select level 1
                if selectedLevel == 0 {
                    selectedLevel = 1
                }
            }
        }
    }
    
    func updateLevels() {
        for i in 0..<levels.count {
            let levelNumber = levels[i].number
            let isUnlocked = nav.isLevelUnlocked(levelNumber)
            levels[i].status = isUnlocked ? .unlocked : .locked
        }
    }
}

struct LevelCell: View {
    let level: Level
    let isSelected: Bool
    let onTap: () -> Void
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Level frame (orange if unlocked, gray if locked)
                if level.status == .unlocked {
                    Image("orangeFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.05, height: screenWidth * 0.06)
                } else {
                    Image("gameRect")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.05, height: screenWidth * 0.06)
                }
                
                // Level number
                Text("\(level.number)")
                    .font(.custom("JosefinSans-Bold", size: screenWidth * 0.03))
                    .foregroundColor(.white)
                
                // Player icon on selected level (offset up by half frame height)
                if isSelected {
                    Image(nav.getPlayerImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.035)
                        .offset(y: -screenWidth * 0.05)
                }
            }
            
        }
        .disabled(level.status == .locked)
    }
}

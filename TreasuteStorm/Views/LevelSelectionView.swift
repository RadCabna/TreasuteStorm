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
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var selectedLevel: Int = 1
    @State private var levels: [Level] = [
        Level(number: 1, status: .unlocked),
        Level(number: 2, status: .unlocked),
        Level(number: 3, status: .unlocked),
        Level(number: 4, status: .locked),
        Level(number: 5, status: .locked),
        Level(number: 6, status: .locked),
        Level(number: 7, status: .locked),
        Level(number: 8, status: .locked),
        Level(number: 9, status: .locked),
        Level(number: 10, status: .locked),
        Level(number: 11, status: .locked),
        Level(number: 12, status: .locked),
        Level(number: 13, status: .locked),
        Level(number: 14, status: .locked),
        Level(number: 15, status: .locked)
    ]
    
    var body: some View {
        ZStack {
            
            // Levels grid (3 rows, 5 columns)
            VStack(spacing: screenWidth * 0.01) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: screenWidth * 0.01) {
                        ForEach(0..<5, id: \.self) { col in
                            let levelIndex = row * 5 + col
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
    }
}

struct LevelCell: View {
    let level: Level
    let isSelected: Bool
    let onTap: () -> Void
    
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
                    Image("menuPers_1")
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

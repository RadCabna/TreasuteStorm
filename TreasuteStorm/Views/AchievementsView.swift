import SwiftUI

enum AchievementStatus {
    case locked
    case unlocked
    case claimed
}

struct Achievement {
    let id: Int
    var status: AchievementStatus
    
    var imageNameOff: String {
        return "achieveOff_\(id)"
    }
    
    var imageNameOn: String {
        return "achieveOn_\(id)"
    }
}

// MARK: - Achievements Content
struct AchievementsContent: View {
    @Binding var currentMenu: MenuState
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var currentAchievementIndex: Int = 0
    @State private var slideDirection: CGFloat = 0
    @State private var achievements: [Achievement] = [
        Achievement(id: 1, status: .unlocked),
        Achievement(id: 2, status: .locked),
        Achievement(id: 3, status: .locked),
        Achievement(id: 4, status: .locked),
        Achievement(id: 5, status: .locked),
        Achievement(id: 6, status: .locked),
        Achievement(id: 7, status: .locked)
    ]
    
    var currentAchievement: Achievement {
        achievements[currentAchievementIndex]
    }
    
    var body: some View {
        ZStack {
            // Achievement frame in center
            Image("shopItemFrame")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.25)
                .padding(screenWidth*0.0265)
            
            // Achievement image with slide animation
            ZStack {
                if currentAchievement.status == .locked {
                    Image(currentAchievement.imageNameOff)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: screenWidth * 0.2, maxHeight: screenWidth * 0.2)
                        .offset(x: slideDirection)
                } else {
                    Image(currentAchievement.imageNameOn)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: screenWidth * 0.2, maxHeight: screenWidth * 0.2)
                        .offset(x: slideDirection)
                }
            }
            .frame(width: screenWidth * 0.25)
            .clipped()
            
            // Left arrow
            HStack {
                Button(action: {
                    previousAchievement()
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
                    nextAchievement()
                }) {
                    Image("shopArrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.04)
                        .scaleEffect(x: -1, y: 1)
                }
                .offset(x: screenWidth * 0.16)
            }
            
            // Reward button (bottom, half outside) - only for unlocked achievements
            if currentAchievement.status == .unlocked {
                VStack {
                    Button(action: {
                        claimReward()
                    }) {
                        Image("achieve10")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.12)
                    }
                    .offset(y: screenWidth * 0.12)
                }
            }
        }
    }
    
    func claimReward() {
        nav.coins += 10
        nav.saveCoins()
        achievements[currentAchievementIndex].status = .claimed
    }
    
    func nextAchievement() {
        let nextIndex = (currentAchievementIndex + 1) % achievements.count
        
        withAnimation(.easeInOut(duration: 0.3)) {
            slideDirection = -screenWidth * 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentAchievementIndex = nextIndex
            slideDirection = screenWidth * 0.3
            
            withAnimation(.easeInOut(duration: 0.15)) {
                slideDirection = 0
            }
        }
    }
    
    func previousAchievement() {
        let prevIndex = (currentAchievementIndex - 1 + achievements.count) % achievements.count
        
        withAnimation(.easeInOut(duration: 0.3)) {
            slideDirection = screenWidth * 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentAchievementIndex = prevIndex
            slideDirection = -screenWidth * 0.3
            
            withAnimation(.easeInOut(duration: 0.15)) {
                slideDirection = 0
            }
        }
    }
}

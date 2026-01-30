import SwiftUI

// MARK: - Settings Content
struct SettingsContent: View {
    @Binding var currentMenu: MenuState
    @ObservedObject private var settings = SettingsManager.shared
    
    var body: some View {
        SettingsGrid(isMusicOn: $settings.isMusicOn, volumeLevel: $settings.volumeLevel)
    }
}

struct SettingsGrid: View {
    @Binding var isMusicOn: Bool
    @Binding var volumeLevel: Double
    let rows = 7
    let columns = 8
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    let rowSpacing = UIScreen.main.bounds.width * 0.005
    
    var body: some View {
        ZStack {
            // Background grid (all cells)
            VStack(spacing: rowSpacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: cellSpacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            // Row 3 (4-й ряд), columns 1-6 (со 2-й по 7-ю клетки) - gameRectOff
                            if row == 3 && column >= 1 && column <= 6 {
                                Image("gameRectOff")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cellWidth, height: cellHeight)
                                    .opacity(0.3)
                            } else {
                                Image("gameRect")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cellWidth, height: cellHeight)
                                    .opacity(0.3)
                            }
                        }
                    }
                }
            }
            
            // Content overlay
            VStack(spacing: rowSpacing) {
                // Row 0 - Music
                SettingsMusicRow(isMusicOn: $isMusicOn)
                
                // Row 1 - Volume text
                SettingsVolumeTextRow()
                
                // Row 2 - Volume slider
                SettingsVolumeSliderRow(volumeLevel: $volumeLevel)
                
                // Row 3 - Empty
                Color.clear.frame(height: cellHeight)
                
                // Row 4 - Language
                SettingsLanguageRow()
                
                // Row 5 - Empty
                Color.clear.frame(height: cellHeight)
                
                // Row 6 - Empty
                Color.clear.frame(height: cellHeight)
            }
        }
    }
}

struct SettingsMusicRow: View {
    @Binding var isMusicOn: Bool
    @ObservedObject private var localization = LocalizationManager.shared
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    
    var body: some View {
        HStack(spacing: 0) {
            // Text on the left with padding
            HStack {
                Text(localization.localized("Music"))
                    .font(.custom("JosefinSans-Bold", size: screenWidth * 0.02))
                    .foregroundColor(.black)
                    .padding(.leading, screenWidth * 0.015)
                Spacer()
            }
            .frame(width: cellWidth * 6 + cellSpacing * 5, height: cellHeight)
            
            Spacer()
                .frame(width: cellSpacing)
            
            // On/Off buttons on the right
            HStack(spacing: cellSpacing) {
                // On button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isMusicOn = true
                    }
                }) {
                    ZStack {
                        if isMusicOn {
                            Image("orangeFrame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: cellWidth, height: cellHeight)
                            
                            Text("On")
                                .font(.custom("JosefinSans-Bold", size: screenWidth * 0.016))
                                .foregroundColor(.white)
                        } else {
                            Image("gameRect")
                                .resizable()
                                .scaledToFit()
                                .frame(width: cellWidth, height: cellHeight)
                        }
                    }
                }
                
                // Off button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isMusicOn = false
                    }
                }) {
                    ZStack {
                        if !isMusicOn {
                            Image("orangeFrame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: cellWidth, height: cellHeight)
                            
                            Text("Off")
                                .font(.custom("JosefinSans-Bold", size: screenWidth * 0.016))
                                .foregroundColor(.white)
                        } else {
                            Image("gameRect")
                                .resizable()
                                .scaledToFit()
                                .frame(width: cellWidth, height: cellHeight)
                        }
                    }
                }
            }
        }
    }
}

struct SettingsVolumeTextRow: View {
    @ObservedObject private var localization = LocalizationManager.shared
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    
    var body: some View {
        HStack {
            Text(localization.localized("Volume"))
                .font(.custom("JosefinSans-Bold", size: screenWidth * 0.02))
                .foregroundColor(.black)
                .padding(.leading, screenWidth * 0.015)
            Spacer()
        }
        .frame(width: cellWidth * 8 + cellSpacing * 7, height: cellHeight)
    }
}

struct SettingsVolumeSliderRow: View {
    @Binding var volumeLevel: Double
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    
    var body: some View {
        let totalWidth = cellWidth * 8 + cellSpacing * 7
        let orangeWidth = totalWidth * CGFloat(volumeLevel)
        
        ZStack(alignment: .leading) {
            // Background - gameRect на всю ширину (непрозрачный)
            HStack(spacing: cellSpacing) {
                ForEach(0..<8, id: \.self) { _ in
                    Image("gameRect")
                        .resizable()
                        .scaledToFit()
                        .frame(width: cellWidth, height: cellHeight)
                }
            }
            
            // Foreground - orangeFrame переменной ширины
            HStack(spacing: 0) {
                Image("orangeFrame")
                    .resizable()
                    .frame(width: max(0, orangeWidth), height: cellHeight)
                    .clipped()
            }
        }
        .frame(width: totalWidth, height: cellHeight)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let newLevel = max(0, min(1, value.location.x / totalWidth))
                    volumeLevel = newLevel
                }
        )
    }
}

struct SettingsLanguageRow: View {
    @ObservedObject private var localization = LocalizationManager.shared
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    
    var body: some View {
        HStack(spacing: cellSpacing) {
            // Language text on the left (4 cells width)
            HStack {
                Text(localization.localized("Language"))
                    .font(.custom("JosefinSans-Bold", size: screenWidth * 0.018))
                    .foregroundColor(.black)
                    .padding(.leading, screenWidth * 0.015)
                Spacer()
            }
            .frame(width: cellWidth * 4 + cellSpacing * 3, height: cellHeight)
            
            // Single language button on the right (4 cells width)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    switchToNextLanguage()
                }
            }) {
                ZStack {
                    Image("orangeFrame")
                        .resizable()
                        .frame(width: cellWidth * 4 + cellSpacing * 3, height: cellHeight)
                    
                    Text(localization.currentLanguage.rawValue)
                        .font(.custom("JosefinSans-Bold", size: screenWidth * 0.02))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    func switchToNextLanguage() {
        let allLanguages = Language.allCases
        if let currentIndex = allLanguages.firstIndex(of: localization.currentLanguage) {
            let nextIndex = (currentIndex + 1) % allLanguages.count
            localization.currentLanguage = allLanguages[nextIndex]
        }
    }
}

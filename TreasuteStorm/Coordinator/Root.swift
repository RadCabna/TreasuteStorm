import SwiftUI
import UIKit

enum LoaderStatus {
    case LOADING
    case DONE
    case ERROR
}

struct RootView: View {
    @State private var status: LoaderStatus = .LOADING
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    let url: URL = URL(string: "https://atreasstorm.pro/profile?page=test")!
    
    @ObservedObject private var orientationManager: OrientationManager = OrientationManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch status {
                case .LOADING, .ERROR:
                    switch nav.currentScreen {
                    case .LOADING:
                        Loading()
                            .edgesIgnoringSafeArea(.all)
                    case .MAIN:
                        Main()
                            .ignoresSafeArea()
                    case .ONBOARDING:
                        EmptyView()
                    }
                case .DONE:
                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                        
                        GameLoader_1E6704B4Overlay(data: GameLoader_1E6704B4Model(url: url))
                            .onAppear {
                                // Разблокируем все ориентации при появлении WebView
                                DispatchQueue.main.async {
                                    orientationManager.unlockAllOrientations()
                                }
                            }
                            .onDisappear {
                                // Блокируем на landscape при исчезновении WebView
                                DispatchQueue.main.async {
                                    orientationManager.lockToLandscape()
                                }
                            }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            Task {
                let result = await GameLoader_1E6704B4StatusChecker().checkStatus(url: url)
                if result {
                    // WebView - разрешаем все ориентации
                    orientationManager.unlockAllOrientations()
                    self.status = .DONE
                } else {
                    // Основное приложение - только landscape ориентация
                    orientationManager.lockToLandscape()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            nav.currentScreen = .MAIN
                        }
                    }
                    self.status = .ERROR
                }
                print("WebView status check result: \(result)")
            }
        }
    }
}

#Preview {
    RootView()
}

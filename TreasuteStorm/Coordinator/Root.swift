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
    @ObservedObject private var orientationManager: OrientationManager = OrientationManager.shared
    let url: URL = URL(string: "https://atreasstorm.pro/profile")!
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch status {
                case .LOADING, .ERROR:
                    switch nav.currentScreen {
                    case .LOADING:
                        Loading()
                            .edgesIgnoringSafeArea(.all)
                            .onAppear {
                                DispatchQueue.main.async {
                                    orientationManager.lockToLandscape()
                                }
                            }
                    case .MAIN:
                        Main()
                            .ignoresSafeArea()
                            .onAppear {
                                DispatchQueue.main.async {
                                    orientationManager.lockToLandscape()
                                }
                            }
                    case .ONBOARDING:
                        EmptyView()
                    }
                case .DONE:
                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                        
                        GameLoader_1E6704B4Overlay(data: GameLoader_1E6704B4Model(url: url))
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            Task {
                let result = await GameLoader_1E6704B4StatusChecker().checkStatus(url: url)
                if result {
                    self.status = .DONE
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            nav.currentScreen = .MAIN
                        }
                    }
                    self.status = .ERROR
                }
            }
        }
    }
}

#Preview {
    RootView()
}

import SwiftUI
import UIKit

struct RootView: View {
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch nav.currentScreen {
                case .LOADING:
                    Loading()
                        .ignoresSafeArea()
                case .MAIN:
                    Main()
                        .ignoresSafeArea()
                case .ONBOARDING:
                    EmptyView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    RootView()
}

//
//  Loading.swift
//  A.Treasure-Storm
//
//  Created by Алкександр Степанов on 29.01.2026.
//

import SwiftUI

struct Loading: View {
    @State private var navigateToMain = false
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    
    var body: some View {
        ZStack {
            // Вертикальный градиент от bgColor_1 до bgColor_2
            LinearGradient(
                gradient: Gradient(colors: [Color("bgColor_1"), Color("bgColor_2")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Логотип по центру размером 1/4 ширины экрана
            Image("gameLoadingLogo")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth / 4)
        }
        .onAppear {
            // Через 5 секунд переходим в главное меню
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    nav.currentScreen = .MAIN
                }
            }
        }
    }
}

#Preview {
    Loading()
}

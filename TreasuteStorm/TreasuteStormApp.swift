//
//  TreasuteStormApp.swift
//  TreasuteStorm
//
//  Created by Алкександр Степанов on 29.01.2026.
//

import SwiftUI

@main
struct TreasuteStormApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = AudioManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

#Preview {
    RootView()
}

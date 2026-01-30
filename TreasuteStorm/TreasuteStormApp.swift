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
        // Initialize AudioManager to set up music system
        _ = AudioManager.shared
        
        // Lock to landscape orientation
        OrientationManager.shared.lockToLandscape()
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

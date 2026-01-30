//
//  AppDelegate.swift
//  TreasuteStorm
//
//  Created by AI Assistant on 30.01.2026.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return OrientationManager.shared.isHorizontalLock ? .landscape : .allButUpsideDown
    }
}

import Foundation
import SwiftUI
import UIKit

class OrientationManager: ObservableObject {
    @Published var isHorizontalLock = true  // Lock to landscape by default
    
    static var shared: OrientationManager = .init()
    
    func lockToLandscape() {
        DispatchQueue.main.async {
            self.isHorizontalLock = true
            self.forceUpdateOrientation()
        }
    }
    
    func unlockAllOrientations() {
        DispatchQueue.main.async {
            self.isHorizontalLock = false
            self.forceUpdateOrientation()
        }
    }
    
    private func forceUpdateOrientation() {
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                print("No window scene found")
                return
            }
            let orientations: UIInterfaceOrientationMask = isHorizontalLock ? .landscape : .allButUpsideDown
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientations)) { error in
                print("Orientation update error: \(error.localizedDescription)")
            }
            
            // Также обновляем все window controllers
            for window in windowScene.windows {
                window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

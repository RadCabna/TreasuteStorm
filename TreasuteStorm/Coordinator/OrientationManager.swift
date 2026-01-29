import SwiftUI
import UIKit

class OrientationManager: ObservableObject {
    @Published var isLandscapeLock = true
    
    static var shared: OrientationManager = .init()
    
    func lockToLandscape() {
        DispatchQueue.main.async {
            self.isLandscapeLock = true
            self.forceUpdateOrientation()
        }
    }
    
    func unlockAllOrientations() {
        DispatchQueue.main.async {
            self.isLandscapeLock = false
            self.forceUpdateOrientation()
        }
    }
    
    private func forceUpdateOrientation() {
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                print("No window scene found")
                return
            }
            let orientations: UIInterfaceOrientationMask = isLandscapeLock ? .landscape : .allButUpsideDown
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientations)) { error in
                print("Orientation update error: \(error.localizedDescription)")
            }
            
            for window in windowScene.windows {
                window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

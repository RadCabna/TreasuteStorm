import Foundation
import SwiftUI
import UIKit

class OrientationManager: ObservableObject {
    @Published var isHorizontalLock = true  // Lock to landscape by default
    
    static var shared: OrientationManager = .init()
    
    func lockToLandscape() {
        isHorizontalLock = true
        forceUpdateOrientation()
    }
    
    func unlockAllOrientations() {
        isHorizontalLock = false
        forceUpdateOrientation()
    }
    
    private func forceUpdateOrientation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Вызываем обновление ориентации
            UIViewController.attemptRotationToDeviceOrientation()
            
            // Для iOS 16+ дополнительно используем requestGeometryUpdate
            if #available(iOS 16.0, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return
                }
                let orientations: UIInterfaceOrientationMask = self.isHorizontalLock ? .landscape : .allButUpsideDown
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientations))
                
                // Принудительно обновляем статус бар (только для iOS 16+)
                UIApplication.shared.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
    }
}

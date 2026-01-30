import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        // If locked to landscape, only allow landscape orientations
        // Otherwise, allow all orientations (for WebView)
        return OrientationManager.shared.isHorizontalLock 
            ? .landscape 
            : .allButUpsideDown
    }
}

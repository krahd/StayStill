import SwiftUI

@main
struct StayStillApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .statusBar(hidden: true) // SwiftUI status bar hide (iOS 14+)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.windowLevel = UIWindow.Level.statusBar + 1
        }
    }
}

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if self.window!.rootViewController as? UITabBarController != nil {
            var tabBarController = self.window!.rootViewController as! UITabBarController
            if(defaults.object(forKey: "launchedBefore") == nil) {
                tabBarController.selectedIndex = 2
            }
            else {
                tabBarController.selectedIndex = 1
            }
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

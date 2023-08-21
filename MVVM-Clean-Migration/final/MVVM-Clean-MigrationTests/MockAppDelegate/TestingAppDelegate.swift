import UIKit

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(">> Launching with testing app delegate")
       
        window = UIWindow()
        window?.rootViewController = TestingRootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

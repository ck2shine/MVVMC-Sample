//
//  AppDelegate.swift
//  MVVM-Clean-Migration
//
//  Created by Chang, Chih Hsiang | Shine | RP on 2023/08/16.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        window = UIWindow()
        let container = PaymentFlowContainer()
        container.registerPaymentMethodDependency()
        let rootVc = UINavigationController(rootViewController: RPPaymentMethodViewController(dependency: container))
        
        self.window?.rootViewController = rootVc
        self.window?.makeKeyAndVisible()
        return true
    }
}

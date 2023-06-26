//
//  AppDelegate.swift
//  MVVM-Clean
//
//  Created by Chang, Chih Hsiang | Shine | RP on 2023/02/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appCoordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        appCoordinator = AppCoordinator(window: self.window)
        appCoordinator?.start()
        return true
    }
}

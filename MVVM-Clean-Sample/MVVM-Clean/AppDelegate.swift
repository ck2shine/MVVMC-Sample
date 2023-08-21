//
//  AppDelegate.swift
//  MVVM-Clean
//
//  Created by Chang, Chih Hsiang | Shine | RP on 2023/02/15.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appInteractor: AppIneractor?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        appInteractor = AppIneractor(window: self.window)
        appInteractor?.start()
        return true
    }
}

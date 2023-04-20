//
//  AppDelegate.swift
//  MVVM-Clean
//
//  Created by Chang, Chih Hsiang | Shine | RP on 2023/02/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        let useCase = BookListDefaultUseCase()
        let viewModel = BookListViewModel(useCase: useCase)
        let vc = BookListViewController(viewModel: viewModel)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

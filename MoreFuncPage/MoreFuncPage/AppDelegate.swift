//
//  AppDelegate.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("沙盒路径: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))")
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVM = RootViewModel(showNavigationBar: true)
        let rootViewController = RootViewController(viewModel: rootVM)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}


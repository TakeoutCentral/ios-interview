//
//  AppDelegate.swift
//  ios-interview-swift
//
//  Created by Mike on 5/16/21.
//

import CFATheme
import FeatureFlags
import UIKit

var CFACurrentTheme: CFATheme { CFAThemeManager.shared().currentTheme }

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if let url = Bundle.main.url(forResource: "feature-flags", withExtension: "json") {
            FeatureFlags.shared.add(
                configuration: LocalConfiguration(jsonURL: url)
            )
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()

        return true
    }
}


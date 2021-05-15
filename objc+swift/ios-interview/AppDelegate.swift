//
//  AppDelegate.swift
//  ios-interview
//
//  Created by Mike on 5/15/21.
//

import CFATheme
import UIKit

var CFACurrentTheme: CFATheme { CFAThemeManager.shared().currentTheme }

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()

        return true
    }
}


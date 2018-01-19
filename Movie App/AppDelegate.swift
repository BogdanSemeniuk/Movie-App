//
//  AppDelegate.swift
//  Movie App
//
//  Created by Богдан Семенюк on 13.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let loginManager = LoginManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var initialVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login")
        
        if loginManager.isLogined {
            initialVC = HomeViewController()
        }
        print(Keychain.sharedStorage.get("session"))
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (window?.rootViewController as? HomeViewController) == nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Token received to login page"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Token received to HomeVC"), object: nil)
        }
        return true
    }
}

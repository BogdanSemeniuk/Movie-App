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
        Keychain.sharedStorage.clear()
        let storyboardName = loginManager.isLogined ? "Movies" : "Login"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifierVC = loginManager.isLogined ? "Movies" : "Login"
        let initialVC = storyboard.instantiateViewController(withIdentifier: identifierVC)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.saveContext()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Token received"), object: nil)
        
        return true
    }
}


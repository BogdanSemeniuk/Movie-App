//
//  AppDelegate.swift
//  Movie App
//
//  Created by Богдан Семенюк on 13.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let loginManager = LoginManager()
        let token = loginManager.getToken()
        
//        let session = loginManager.login(token: token)
//        print(session)
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(token)
        return true
    }
}


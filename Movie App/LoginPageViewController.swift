//
//  LoginPageViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {
    
    private let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPageViewController.getSessionIdAndGoToMovies), name: NSNotification.Name(rawValue: "Token received"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        loginManager.getTokenAndRedirectToApp()
    }
    
    @IBAction func actionGuestButton(_ sender: UIButton) {
        guard InternetConnection.shared.isConnectedToInternet else {
            print("No internet connection")
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationHome")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
    @objc func getSessionIdAndGoToMovies()  {
        loginManager.getSessionId(complition: {
            let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "NavigationMovies")
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        })
    }
    
}

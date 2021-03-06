//
//  LoginPageViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginManager = LoginManager()
    
    // MARK: - Life cykl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPageViewController.getSessionIdAndGoToMovies), name: NSNotification.Name(rawValue: "Token received to login page"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        loginManager.getTokenAndRedirectToApp()
    }
    
    @IBAction func actionGuestButton(_ sender: UIButton) {
        guard InternetConnection.shared.isConnectedToInternet else {
            let alert = UIAlertController(title: "No internet connection!", message: "You need to get the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        goToMoviesVC()
    }
    
    // MARK: - Methods
    
    @objc func getSessionIdAndGoToMovies()  {
        loginManager.getSessionId(complition: {
            self.goToMoviesVC()
        })
    }
    
    private func goToMoviesVC() {
        let homeVC = HomeViewController()
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = homeVC
    }
}

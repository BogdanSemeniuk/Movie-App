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
    }
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        loginManager.getToken()
    }
    
    @IBAction func actionGuestButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationHome")
        self.present(vc!, animated: true, completion: nil)
    }
    
}

//
//  HomeViewController.swift
//  Movie App
//
//  Created by Bogdan on 29.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
//    lazy var upcomingNC: UINavigationController = UINavigationController()
//    lazy var favouritesNC: UINavigationController = UINavigationController()
    lazy var upcomingVC: MoviesViewController = MoviesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = UINavigationController()
        
        
        
        upcomingVC = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "MoviesVC") as! MoviesViewController
        nc.viewControllers.append(upcomingVC)
        createMenuButton(viewController: upcomingVC)
        embed(viewController: nc, in: view)
        
        
        
//        addChildViewController(upcomingNC)
//        view.addSubview(upcomingNC.view)
//        upcomingNC.view.frame = view.bounds
//        upcomingNC.didMove(toParentViewController: self)
        
//        remove(viewController: upcomingNC)
        
//        upcomingNC.willMove(toParentViewController: nil)
//        upcomingNC.view.removeFromSuperview()
//        upcomingNC.removeFromParentViewController()
//
//        addChildViewController(favouritesNC)
//        remove(viewController: favouritesNC)
    }
    
    func createMenuButton(viewController: UIViewController) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "multimedia"), for: .normal)
        button.addTarget(self, action: #selector(menuTouched), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let barButton = UIBarButtonItem(customView: button)
        viewController.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func menuTouched() {
        let menuTableVC = MenuTableViewController()
        menuTableVC.complition = { selectedItem in
            print(selectedItem)
        }
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuTableVC)
        menuLeftNavigationController.navigationBar.barTintColor = UIColor.blue
        
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuCustomization()

        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func menuCustomization() {
        SideMenuManager.defaultManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.defaultManager.menuAnimationFadeStrength = 0.2
        SideMenuManager.defaultManager.menuShadowOpacity = 0.9
        SideMenuManager.defaultManager.menuShadowRadius = 10
        SideMenuManager.defaultManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "Background1")!)
        
    }
}

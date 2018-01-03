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
    
    lazy var upcomingVC: MoviesViewController = {
        return createMovieVC(kindOfMovie: .upcoming)
    }()
    lazy var popularVC: MoviesViewController = {
        return createMovieVC(kindOfMovie: .popular)
    }()
    lazy var topRatedVC: MoviesViewController = {
        return createMovieVC(kindOfMovie: .topRated)
    }()
    lazy var nowPlayingVC: MoviesViewController = {
        return createMovieVC(kindOfMovie: .nowPlaying)
    }()
    let nc = UINavigationController()
    
    var selectedMenuItem: MenuItem = .upcoming {
        didSet {
            switch selectedMenuItem {
            case .popular:
                setContent(vc: popularVC)
            case .upcoming:
                setContent(vc: upcomingVC)
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent(vc: upcomingVC)
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
        createMenu()
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func menuCustomization() {
        SideMenuManager.defaultManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.defaultManager.menuAnimationFadeStrength = 0.2
        SideMenuManager.defaultManager.menuShadowOpacity = 0.9
        SideMenuManager.defaultManager.menuShadowRadius = 10
        SideMenuManager.defaultManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "Background1")!)
    }
    
    func createMovieVC(kindOfMovie: MovieSort) -> MoviesViewController{
        let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "MoviesVC") as! MoviesViewController
        vc.kindOfMovies = kindOfMovie
        return vc
    }
    
    func createMenu() {
        let menuTableVC = MenuTableViewController()
        menuTableVC.complition = {[unowned self] selectedItem in
            if self.selectedMenuItem != selectedItem {
                self.removeFromContent()
                self.selectedMenuItem = selectedItem
            }
        }
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuTableVC)
        menuLeftNavigationController.navigationBar.barTintColor = UIColor.blue
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuCustomization()
    }
    
    func removeFromContent() {
        remove(viewController: nc)
    }
    
    func setContent(vc: MoviesViewController) {
        nc.viewControllers.removeAll()
        nc.viewControllers.append(vc)
        createMenuButton(viewController: vc)
        embed(viewController: nc, in: view)
    }
}

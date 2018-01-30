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
    
    private lazy var upcomingVC: MoviesViewController = {
        return MoviesViewController.create(kindOfMovie: .upcoming)
    }()
    private lazy var popularVC: MoviesViewController = {
        return MoviesViewController.create(kindOfMovie: .popular)
    }()
    private lazy var topRatedVC: MoviesViewController = {
        return MoviesViewController.create(kindOfMovie: .topRated)
    }()
    private lazy var nowPlayingVC: MoviesViewController = {
        return MoviesViewController.create(kindOfMovie: .nowPlaying)
    }()
    private lazy var watchlistVC: UIViewController = {
        return WatchlistViewController.create()
    }()
    private let nc = UINavigationController()
    private let loginManager = LoginManager()
    
    var selectedMenuItem: MenuItem = .upcoming {
        didSet {
            switch selectedMenuItem {
            case .popular:
                setContent(vc: popularVC)
            case .upcoming:
                setContent(vc: upcomingVC)
            case .topRated:
                setContent(vc: topRatedVC)
            case .nowPlaying:
                setContent(vc: nowPlayingVC)
            case .myList:
                setContent(vc: watchlistVC)
            default:
                break
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.getSessionId), name: NSNotification.Name("Token received to HomeVC"), object: nil)
        setContent(vc: upcomingVC)
        createMenu()
    }
    
    func createMenuButton(viewController: UIViewController) {
        let barButton = UIBarButtonItem(image: UIImage(named: "multimedia"), style: .plain, target: self, action: #selector(menuTouched))
        viewController.navigationItem.leftBarButtonItem = barButton
        viewController.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    }
    
    @objc func menuTouched() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func menuCustomization() {
        SideMenuManager.defaultManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.defaultManager.menuAnimationFadeStrength = 0.2
        SideMenuManager.defaultManager.menuShadowOpacity = 0.9
        SideMenuManager.defaultManager.menuShadowRadius = 10
    }
    
    func createMenu() {
        let menuTableVC = MenuTableViewController()
        menuTableVC.complition = {[unowned self] selectedItem in
            if self.selectedMenuItem != selectedItem {
                switch selectedItem {
                case .topRated, .nowPlaying, .popular, .upcoming:
                    self.removeFromContent()
                    self.selectedMenuItem = selectedItem
                case .login:
                    self.loginManager.getTokenAndRedirectToApp()
                case .logout:
                    Keychain.sharedStorage.clear()
                case .myList:
                    self.removeFromContent()
                    self.selectedMenuItem = selectedItem
                default:
                    break
                }
            }
        }
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuTableVC)
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuCustomization()
    }
    
    func removeFromContent() {
        remove(viewController: nc)
    }
    
    func setContent(vc: UIViewController) {
        nc.viewControllers.removeAll()
        nc.viewControllers.append(vc)
        createMenuButton(viewController: vc)
        embed(viewController: nc, in: view)
    }
    
    @objc func getSessionId() {
        loginManager.getSessionId {
        }
    }
}

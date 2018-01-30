//
//  MenuTableViewController.swift
//  Movie App
//
//  Created by Bogdan on 02.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit

enum MenuItem {
    case upcoming
    case popular
    case topRated
    case nowPlaying
    case search
    case myList
    case logout
    case login
}

class MenuTableViewController: UITableViewController {

    private let loginManager = LoginManager()
    private var content = [String]()
    private let menuUser = ["Upcoming", "Popular", "Top Rated", "Now Playing", "Search", "My List", "Logout"]
    private let menuGuest = ["Upcoming", "Popular", "Top Rated", "Now Playing", "Search", "Login"]
    
    var complition: ((MenuItem)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        tableView.backgroundColor = UIColor.clear
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        content = loginManager.isLogined ? menuUser : menuGuest
        
        if tableView.numberOfRows(inSection: 0) != content.count {
            tableView.reloadData()
        }
    }

    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        cell.textLabel?.font = UIFont(name: "AmericanTypewriter-CondensedBold", size: 32.0)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        cell.textLabel?.text = content[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem: MenuItem
        switch indexPath.row {
        case 0:
            selectedItem = MenuItem.upcoming
        case 1:
            selectedItem = MenuItem.popular
        case 2:
            selectedItem = MenuItem.topRated
        case 3:
            selectedItem = MenuItem.nowPlaying
        case 4:
            selectedItem = MenuItem.search
        case 5:
            selectedItem = loginManager.isLogined ? MenuItem.myList : MenuItem.login
        case 6:
            selectedItem = MenuItem.logout
        default:
            return
        }
        complition?(selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heigh = view.bounds.size.height / CGFloat(max(menuUser.count, menuGuest.count))
        return heigh
    }
}

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
    var selectedItem: MenuItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clear
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        
        content = loginManager.isLogined ? menuUser : menuGuest
    }

    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        let attributs = [NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter-CondensedBold", size: 30.0) as Any]
        let attributedStr = NSMutableAttributedString(string: content[indexPath.row], attributes: attributs)
        
        cell.textLabel?.attributedText = attributedStr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            break
        }
        complition?(selectedItem!)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heigh = view.bounds.size.height / CGFloat(max(menuUser.count, menuGuest.count))
        return heigh
    }
}

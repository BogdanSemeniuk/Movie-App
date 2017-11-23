//
//  HomePageViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let moviesManager = MovieManager()
    var moviesContent = [Movie]()
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesManager.getPopularMovies(page: 1, complition: { [unowned self] movies in
            if let result = movies.results {
                self.moviesContent = result
                self.reloadTableView()
            }
        })
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        let cell = MovieCell()
        cell.backgroundColor = UIColor.red
        //cell.posterImage = UIImageView.init(image: UIImage(named: "playstation_320x480"))
        cell.posterImage.image = UIImage(named: "playstation_320x480")
        return cell
    }
    
    // MARK: - Methods
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

//
//  WatchlistViewController.swift
//  Movie App
//
//  Created by Bogdan on 08.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let watchlistManager = WatchlistManager()
    
    var frc: NSFetchedResultsController<MovieObj> = {
        let fetchRequest = NSFetchRequest<MovieObj>(entityName: "MovieObj")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let frController = NSFetchedResultsController(fetchRequest:
        fetchRequest, managedObjectContext:
        CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frController.performFetch()
        } catch {
            print(error)
        }
        return frController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchlistManager.printAllMoviesInBase()
        watchlistManager.getMoviesFromWatchlist(page: 1) { (movies) in
            self.watchlistManager.updateBaseIfNeed(movies: movies.results!)
        }
        navigationItem.title = "My Watchlist"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = frc.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchCell", for: indexPath) as! WatchlistCell
        let movie = frc.object(at: indexPath)
        cell.configureCell(movie: movie)
        return cell
    }

    static func create() -> UIViewController {
        let vc = UIStoryboard(name: "Watchlist", bundle: nil).instantiateViewController(withIdentifier: "WatchlistVC")
        return vc
    }
}

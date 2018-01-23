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

class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    private let watchlistManager = WatchlistManager()
    private lazy var internetConnectionManager = InternetConnection()
    
    private lazy var frc: NSFetchedResultsController<MovieObj> = {
        let fetchRequest = NSFetchRequest<MovieObj>(entityName: "MovieObj")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let frController = NSFetchedResultsController(fetchRequest:
        fetchRequest, managedObjectContext:
        CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        frController.delegate = self
        do {
            try frController.performFetch()
        } catch {
            print(error)
        }
        return frController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Watchlist"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBaseIfNeeded()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return internetConnectionManager.isConnectedToInternet
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removableMovieId = frc.object(at: indexPath).id
            watchlistManager.removeOrAddMovie(withId: Int(removableMovieId), needToAdd: false, complition: {
                self.updateBaseIfNeeded()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
        let movie = frc.object(at: indexPath)
        vc.movieDetails = Movie(id: Int(movie.id), genres: nil, budget: nil, title: movie.title!, overview: nil, posterPath: movie.poster, countries: nil, releaseDate: "", credits: nil, voteAverage: movie.voteAverage, voteCount: Int(movie.voteCount), genreIds: movie.genres)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func controllerWillChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? WatchlistCell  {
                let movie = frc.object(at: indexPath)
                cell.configureCell(movie: movie)
            }
            break;
        }
    }
    
    private func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    private func updateBaseIfNeeded() {
        watchlistManager.getMoviesFromWatchlist(page: 1) { (movies) in
            self.watchlistManager.updateBaseIfNeeded(moviesFromResponse: movies.results!)
        }
    }
    
    static func create() -> UIViewController {
        let vc = UIStoryboard(name: "Watchlist", bundle: nil).instantiateViewController(withIdentifier: "WatchlistVC")
        return vc
    }
}

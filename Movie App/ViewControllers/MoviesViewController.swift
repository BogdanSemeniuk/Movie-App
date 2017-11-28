//
//  HomePageViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let moviesManager = MovieManager()
    let genresManager = GenreManager()
    var moviesContent = [Movie]()
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CoreDataManager.instance.storageIsEmpty() {
            genresManager.getGenres(complition: { allGenres in
                CoreDataManager.instance.saveGanres(genres: allGenres.genres)
            })
        }
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
        
        tableView.estimatedRowHeight = 500.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let movie = moviesContent[indexPath.row]
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        guard let posterPath = movie.posterPath else {return UITableViewCell()}
        let urlPoster = createPosterURL(path: posterPath)
        cell.posterImageView.kf.setImage(with: urlPoster)
        
        cell.titleLabel.text = movie.title
        cell.ratingLabel.text = String(movie.voteAverage)
        cell.genresLabel.text = createGenresString(genresId: movie.genreIds)
        
        return cell
    }
    
    // MARK: - Methods
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    private func createPosterURL(path: String) -> URL? {
        let url = URL(string: "http://image.tmdb.org")
        let path = "t/p/w342/" + path
        let posterPath = URL(string: path, relativeTo: url!)
        return posterPath
    }
    
    private func createGenresString(genresId: [Int]) -> String {
        var genresString = ""
        let count = genresId.count
        for (index, id) in genresId.enumerated() {
            let genre = CoreDataManager.instance.getGenreNameWithId(id: id)
            switch index {
            case count - 1:
                genresString = genresString + genre
            default:
                genresString = genresString + genre + "," + " "
            }
        }
        return genresString
    }
}

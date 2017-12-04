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
    
    private let moviesManager = MovieManager()
    private let genresManager = GenreManager()
    private var moviesContent = [Movie]()
    private var currentPage = 1
    private var responseFetchedUp = false
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CoreDataManager.instance.storageIsEmpty() {
            genresManager.getGenres(complition: {allGenres in
                CoreDataManager.instance.saveGanres(genres: allGenres.genres)
            })
        }
        getMovies()
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
        cell.genresLabel.text = cell.createGenresString(genresId: movie.genreIds)
        cell.yearLabel.text = cell.createYearString(date: movie.releaseDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
        vc.movieId = moviesContent[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Scroll View
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && responseFetchedUp {
            getMovies()
            responseFetchedUp = false
        }
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
    
    private func getMovies() {
        moviesManager.getUpcomingMovies(page: currentPage, complition: { [unowned self] movies in
            if let result = movies.results {
                self.moviesContent+=result
                self.reloadTableView()
                self.currentPage+=1
                self.responseFetchedUp = true
            }
        })
    }
}

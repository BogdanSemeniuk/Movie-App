//
//  HomePageViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher

enum MovieSort {
    case upcoming
    case popular
    case topRated
    case nowPlaying
}

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let moviesManager = MovieManager()
    private let genresManager = GenreManager()
    private var moviesContent = [Movie]()
    private var currentPage = 1
    private var responseFetchedUp = false
    var kindOfMovies: MovieSort = .upcoming
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitileAndBackgroundColor()
        genresManager.updateIfNeeded()
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
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        cell.selectedBackgroundView = view
        
        setCellContent(of: cell, withMovie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
        vc.movieDetails = moviesContent[indexPath.row]
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
        switch kindOfMovies {
        case .upcoming:
            moviesManager.getUpcomingMovies(page: currentPage, complition: { [unowned self] movies in
                self.changeCurrentPageAndUpdateContent(movies: movies)
            })
        case .popular:
            moviesManager.getPopularMovies(page: currentPage, complition: { [unowned self] movies in
                    self.changeCurrentPageAndUpdateContent(movies: movies)
                })
        case .topRated:
            moviesManager.getTopRatedMovies(page: currentPage, complition: { [unowned self] movies in
                self.changeCurrentPageAndUpdateContent(movies: movies)
            })
        case .nowPlaying:
            moviesManager.getNowPlayingMovies(page: currentPage, complition: { [unowned self] movies in
                self.changeCurrentPageAndUpdateContent(movies: movies)
            })
        }
    }
    
    func changeCurrentPageAndUpdateContent(movies: PackageOfMovies) {
        if let result = movies.results {
            self.moviesContent+=result
            self.reloadTableView()
            self.currentPage += 1
            self.responseFetchedUp = true
        }
    }
    
    func setNavigationTitileAndBackgroundColor() {
        let textAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        var navigationTitle = ""
        switch kindOfMovies {
        case .nowPlaying:
            navigationTitle = "Now Playing Movies"
        case .upcoming:
            navigationTitle = "Upcoming Movies"
        case .topRated:
            navigationTitle = "Top Rated Movies"
        case .popular:
            navigationTitle = "Popular Movies"
        }
        navigationItem.title = navigationTitle
    }
    
    private func setCellContent(of cell: MovieCell, withMovie movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        let urlPoster = createPosterURL(path: posterPath)
        cell.posterImageView.kf.setImage(with: urlPoster)
        
        cell.titleLabel.text = movie.title
        cell.ratingLabel.text = String(movie.voteAverage)
        cell.genresLabel.text = createGenresString(genresId: movie.genreIds!)
        cell.yearLabel.text = createYearString(date: movie.releaseDate)
    }
    
    static func create(kindOfMovie: MovieSort) -> MoviesViewController {
        let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "MoviesVC") as! MoviesViewController
        vc.kindOfMovies = kindOfMovie
        return vc
    }
}

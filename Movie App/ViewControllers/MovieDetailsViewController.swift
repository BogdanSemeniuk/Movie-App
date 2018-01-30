//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 04.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    @IBOutlet weak var trailerLabel: UILabel!
    @IBOutlet weak var addOrRemoveButton: UIButton!
    
    
    private let moviesManager = MovieManager()
    private lazy var loginMamager = LoginManager()
    private lazy var watchlistManager = WatchlistManager()
    var movieDetails: Movie!
    var isMovieInWatchlist: Bool? {
        didSet {
            let imageName = isMovieInWatchlist! ? "deleteButton" : "addButton"
            addOrRemoveButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
        }
    }
    var overview: String? {
        didSet {
            overviewLabel.text = overview != nil ? "Overview: " + overview! : "Overview: "
        }
    }
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movieDetails.title
        releaseLabel.text = createYearString(date: movieDetails.releaseDate)
        genresLabel.text = createGenresString(genresId: movieDetails.genreIds!)
        overview = movieDetails.overview
        budgetLabel.text = ""
        countryLabel.text = ""
        videoPlayerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        trailerLabel.text = ""
        addOrRemoveButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        guard let posterPath = movieDetails.posterPath else {return}
        let urlPoster = createPosterURL(path: posterPath)
        posterImageView.kf.setImage(with: urlPoster)
        moviesManager.getMovieDetails(id: movieDetails.id) { [weak self] (movieInfo) in
            self?.movieDetails = movieInfo
            self?.budgetLabel.text = createBudgetString(budget: movieInfo.budget)
            self?.countryLabel.text = createCountriesString(countries: movieInfo.countries)
            self?.directorLabel.text = createDirectorsString(crew: movieInfo.credits?.crew)
            self?.overview = movieInfo.overview
            self?.releaseLabel.text = createYearString(date: movieInfo.releaseDate)
            self?.actorsLabel.text = createActorsString(cast: movieInfo.credits?.cast)
        }
        moviesManager.getMovieImages(id: movieDetails.id) { [weak self] (images) in
            let vc = self?.childViewControllers.first as! ImagesViewController
            vc.postersAndBackdrops = images
        }
        moviesManager.getMovieVideos(id: movieDetails.id) { [weak self] (videos) in
            if let trailer = videos.results.first {
                self?.trailerLabel.text = "Official Trailer"
                self?.videoPlayerView.load(withVideoId: trailer.key)
            } else {
                self?.trailerLabel.isHidden = true
                self?.videoPlayerView.isHidden = true
            }
        }
        setButton()
        setBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ratingView.showRatingWithAnimation(rating: movieDetails.voteAverage)
    }
    
    @IBAction func addOrRemoveButtonTouched() {
        if let movieInWatchlist = isMovieInWatchlist {
            watchlistManager.removeOrAddMovie(withId: movieDetails.id, needToAdd: !movieInWatchlist, complition: { [weak self] in
                self?.setButton()
            })
        } 
    }
    
    private func setBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "back button1"), style: .plain, target: self, action: #selector(backButtonTouched))
        backButton.tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setButton() {
        if loginMamager.isLogined {
            moviesManager.isWatchlistContainMovie(id: movieDetails.id) { [weak self] (response) in
                self?.isMovieInWatchlist = response.watchlist
            }
        } else {
            addOrRemoveButton.removeFromSuperview()
        }
    }
}

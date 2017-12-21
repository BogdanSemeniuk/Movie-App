//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 04.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    private let moviesManager = MovieManager()
    var movieDetails: Movie!
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movieDetails.title
        releaseLabel.text = createYearString(date: movieDetails.releaseDate)
        genresLabel.text = createGenresString(genresId: movieDetails.genreIds!)
        overviewLabel.text = "Overview: " + movieDetails.overview
        budgetLabel.text = ""
        countryLabel.text = ""
        
        guard let posterPath = movieDetails.posterPath else {return}
        let urlPoster = createPosterURL(path: posterPath)
        posterImageView.kf.setImage(with: urlPoster)
        
        moviesManager.getMovieDetails(id: movieDetails.id) { [weak self] (movieInfo) in
            self?.movieDetails = movieInfo
            self?.budgetLabel.text = createBudgetString(budget: movieInfo.budget)
            self?.countryLabel.text = createCountriesString(countries: movieInfo.countries)
            self?.directorLabel.text = createDirectorsString(crew: movieInfo.credits?.crew)
            self?.actorsLabel.text = createActorsString(cast: movieInfo.credits?.cast)
        }
        moviesManager.getMovieImages(id: movieDetails.id) { [weak self] (images) in
            let vc = self?.childViewControllers.first as! ImagesCollectionViewController
            vc.postersAndBackdrops = images
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ratingView.showRatingWithAnimation(rating: movieDetails.voteAverage)
    }
}

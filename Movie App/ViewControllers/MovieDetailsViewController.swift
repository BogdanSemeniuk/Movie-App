//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 04.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var movieId: Int? = nil
    private let moviesManager = MovieManager()
    private var movieDetails: MovieDetails!
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesManager.getMovieDetails(id: movieId!) { [unowned self] (movieInfo) in
            self.movieDetails = movieInfo
            print(self.movieDetails)
        }
    }
}

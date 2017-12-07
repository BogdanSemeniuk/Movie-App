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
    
    private let moviesManager = MovieManager()
    var movieDetails: Movie!
    
    // MARK: - Life Cycl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesManager.getMovieDetails(id: movieDetails.id) { [weak self] (movieInfo) in
            self?.movieDetails = movieInfo
            
        }
    }
}

//
//  HomePageViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    let moviesManager = MovieManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MoviesViewController")
        moviesManager.getPopularMovies(page: 1)
    }
}

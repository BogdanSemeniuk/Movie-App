//
//  SearchCell.swift
//  Movie App
//
//  Created by Bogdan on 06.02.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher

class SearchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    func configureCell(withMovie movie: Movie) {
        if let posterPath = movie.posterPath {
            let urlPoster = createPosterURL(path: posterPath)
            self.posterImageView.kf.setImage(with: urlPoster)
        } else {
            let url = URL(string: "https://image.ibb.co/kvjirH/movie_image.jpg")
            self.posterImageView.kf.setImage(with: url)
        }
        
        self.titleLabel.text = movie.title
        self.voteCountLabel.text = String(movie.voteCount)
        self.voteAverageLabel.text = String(movie.voteAverage)
        self.genresLabel.text = createGenresString(genresId: movie.genreIds!)
        self.releaseLabel.text = "Date of release: " + movie.releaseDate
    }
}

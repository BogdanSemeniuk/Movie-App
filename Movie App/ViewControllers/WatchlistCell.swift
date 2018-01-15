//
//  WatchlistCell.swift
//  Movie App
//
//  Created by Bogdan on 08.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class WatchlistCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    func configureCell(movie: MovieObj) {
        self.titleLabel.text = movie.title!
        self.genresLabel.text = createGenresString(genresId: movie.genres!)
        self.voteCount.text = String(movie.voteCount)
        self.voteAverage.text = String(movie.voteAverage)
        
        guard let posterPath = movie.poster else { return }
        let urlPoster = createPosterURL(path: posterPath)
        self.posterImageView.kf.setImage(with: urlPoster)
    }
}

//
//  MoviesCell.swift
//  Movie App
//
//  Created by Богдан Семенюк on 23.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    let genreManager = GenreManager()
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        posterImageView.layer.shadowRadius = 3
        posterImageView.layer.shadowOpacity = 0.7
        posterImageView.layer.shadowPath = UIBezierPath(rect: posterImageView.bounds).cgPath
        posterImageView.layer.shouldRasterize = true
        posterImageView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func createGenresString(genresId: [Int]) -> String {
        return "Genres: " + genresId.map({ id in
            genreManager.getGenreName(id: id)
        }).joined(separator: ", ")
    }
    
    func createYearString(date: String) -> String {
        let year = date.prefix(4)
        return "Release year: " + year
    }
}

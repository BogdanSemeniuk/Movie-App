//
//  MoviesCell.swift
//  Movie App
//
//  Created by Богдан Семенюк on 23.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    func createGenresString(genresId: [Int]) -> String {
        var genresString = ""
        let count = genresId.count
        for (index, id) in genresId.enumerated() {
            let genre = CoreDataManager.instance.getGenreNameWithId(id: id)
            switch index {
            case count - 1:
                genresString = genresString + genre
            default:
                genresString = genresString + genre + "," + " "
            }
        }
        return "Genres: " + genresString
    }
    
    func createYearString(date: String) -> String {
        let year = date.prefix(4)
        return "Release year: " + year
    }
}

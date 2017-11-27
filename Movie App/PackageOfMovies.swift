//
//  PackageOfMovies.swift
//  Movie App
//
//  Created by Богдан Семенюк on 22.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

struct PackageOfMovies: Decodable {
    var results: [Movie]?
}

struct Movie: Decodable {
    var id: Int
    var voteCount: Int
    var voteAverage: Float
    var title: String
    var posterPath: String?
    var overview: String
    var releaseDate: String
    var genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
}
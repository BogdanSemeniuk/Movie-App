//
//  MovieDetails.swift
//  Movie App
//
//  Created by Богдан Семенюк on 04.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

struct MovieDetails: Decodable {
    var genres: [Genre]
    var budget: Int
    var title: String
    var overview: String
    var posterPath: String?
    var countries: [Country]
    var releaseDate: String
    var credits: Credits
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case genres
        case budget
        case countries = "production_countries"
        case credits
    }
}

struct Country: Decodable {
    var name: String
}

struct Actor: Decodable {
    var name: String
    var profilePath: String?
    var order: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case order
    }
}

struct Worker: Decodable {
    var name: String
    var job: String
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case job
        case profilePath = "profile_path"
    }
}

struct Credits: Decodable {
    var cast: [Actor]
    var crew: [Worker]
}






//
//  MovieDetails.swift
//  Movie App
//
//  Created by Богдан Семенюк on 04.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

struct Credits: Decodable {
    var cast: [Actor]
    var crew: [Worker]
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







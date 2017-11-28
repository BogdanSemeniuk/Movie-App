//
//  GenresList.swift
//  Movie App
//
//  Created by Богдан Семенюк on 27.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

struct GenresList: Decodable {
    var genres: [Genre]
}

struct Genre: Decodable {
    var id: Int
    var name: String
}

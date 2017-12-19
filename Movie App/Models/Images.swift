//
//  Images.swift
//  Movie App
//
//  Created by Богдан Семенюк on 20.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

struct Images: Decodable {
    var backdrops: [Backdrop]
    var posters: [Poster]
}

struct Backdrop: Decodable {
    var filePath: String
    var height: Int
    var width: Int
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case height
        case width
    }
}

struct Poster: Decodable {
    var filePath: String
    var height: Int
    var width: Int
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case height
        case width
    }
}

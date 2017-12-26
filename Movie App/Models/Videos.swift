//
//  Videos.swift
//  Movie App
//
//  Created by Bogdan on 26.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

struct Videos: Decodable {
    var results: [Video]
}

struct Video: Decodable {
    var name: String
    var key: String
}

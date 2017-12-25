//
//  GenreAPI.swift
//  Movie App
//
//  Created by Богдан Семенюк on 27.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya

enum GenreAPI {
    case getAllGenre()
}

extension GenreAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        return "genre/movie/list"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US"], encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return [:]
    }
}

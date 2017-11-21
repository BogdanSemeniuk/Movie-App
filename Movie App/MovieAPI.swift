//
//  MovieAPI.swift
//  Movie App
//
//  Created by Богдан Семенюк on 21.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya

enum MovieAPI {
    case getPopularMovies(page: Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        return "movie/popular"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getPopularMovies(page: let page):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "page":page, "region":"UA"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}


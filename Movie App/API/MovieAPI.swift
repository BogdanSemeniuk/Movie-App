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
    case getUpcomingMovies(page: Int)
    case getMovieDetails(id: Int)
    case getAllImages(id: Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .getPopularMovies(page: _):
            return "movie/popular"
        case .getUpcomingMovies(page: _):
            return "movie/upcoming"
        case .getMovieDetails(id: let id):
            return "movie/\(id)"
        case .getAllImages(id: let id):
            return "movie/\(id)/images"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getPopularMovies(page: let page), .getUpcomingMovies(page: let page):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "page":page, "region":"UA"], encoding: URLEncoding.queryString)
        case .getMovieDetails(id:_):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "append_to_response":"credits"], encoding: URLEncoding.queryString)
        case .getAllImages(id: _):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "include_image_language":"null,en"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}


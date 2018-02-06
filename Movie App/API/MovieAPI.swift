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
    case getTopRatedMovies(page: Int)
    case getNowPlayingMovies(page: Int)
    case getMovieDetails(id: Int)
    case getAllImages(id: Int)
    case getMovieTrailers(id: Int)
    case getMovieStatusInWatchlist(id: Int)
    case searchMovies(page: Int, query: String)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .getPopularMovies(_):
            return "movie/popular"
        case .getUpcomingMovies(_):
            return "movie/upcoming"
        case .getTopRatedMovies(_):
            return "movie/top_rated"
        case .getNowPlayingMovies(_):
            return "movie/now_playing"
        case .getMovieDetails(id: let id):
            return "movie/\(id)"
        case .getAllImages(id: let id):
            return "movie/\(id)/images"
        case .getMovieTrailers(id: let id):
            return "movie/\(id)/videos"
        case .getMovieStatusInWatchlist(id: let id):
            return "movie/\(id)/account_states"
        case .searchMovies(_, _):
            return "search/movie"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let sessionId = Keychain.sharedStorage.get("session")
        switch self {
        case .getPopularMovies(page: let page), .getUpcomingMovies(page: let page), .getTopRatedMovies(page: let page), .getNowPlayingMovies(page: let page):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "page":page, "region":"UA"], encoding: URLEncoding.queryString)
        case .getMovieDetails(id:_):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "append_to_response":"credits"], encoding: URLEncoding.queryString)
        case .getAllImages(id: _):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "include_image_language":"null,en"], encoding: URLEncoding.queryString)
        case .getMovieTrailers(id: _):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US"], encoding: URLEncoding.queryString)
        case .getMovieStatusInWatchlist(id: _):
            return .requestParameters(parameters: ["api_key":apiKey, "session_id":sessionId!], encoding: URLEncoding.queryString)
        case .searchMovies(let page, let query):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US", "query":query, "page":page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}


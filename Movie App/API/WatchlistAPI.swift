//
//  WatchlistAPI.swift
//  Movie App
//
//  Created by Bogdan on 08.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

enum WatchlistAPI {
    case getMoviesFromMyWatchlist(page: Int)
    case addMovieToMyWatchlist(id: Int, add: Bool)
}


extension WatchlistAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .getMoviesFromMyWatchlist(page: _):
            return "account/{account_id}/watchlist/movies"
        case .addMovieToMyWatchlist(id: _, add: _):
            return "account/{account_id}/watchlist"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMoviesFromMyWatchlist(page: _):
            return .get
        case .addMovieToMyWatchlist(id: _, add: _):
            return .post
        }
    }
    
    var sampleData: Data {
            return Data()
    }
    
    var task: Task {
        let sessionId = Keychain.sharedStorage.get("session")
        switch self {
        case .getMoviesFromMyWatchlist(page: let page):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US","session_id": sessionId!, "page":page], encoding: URLEncoding.queryString)
        case .addMovieToMyWatchlist(id: _, add: _):
            return .requestParameters(parameters: ["api_key":apiKey, "session_id": sessionId!], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .addMovieToMyWatchlist(id: _, add: _):
            return ["Content-type": "application/json"]
        default:
            return nil
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .addMovieToMyWatchlist(id: let id, add: let add):
            return ["media_type": "movie", "media_id": id, "watchlist": add]
        case .getMoviesFromMyWatchlist(page: _):
            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
}

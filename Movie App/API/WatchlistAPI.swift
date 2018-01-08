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
}

extension WatchlistAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        return "account/{account_id}/watchlist/movies"
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
        case .getMoviesFromMyWatchlist(page: let page):
            return .requestParameters(parameters: ["api_key":apiKey, "language":"en-US","session_id": sessionId!, "page":page], encoding: URLEncoding.queryString)
            
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

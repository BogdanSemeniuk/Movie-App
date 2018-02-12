//
//  MoviesListManager.swift
//  Movie App
//
//  Created by Bogdan on 11.02.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya

protocol MoviesListManager: class {
    func getMovies(page: Int, complition: @escaping (PackageOfMovies) -> ())
}

extension MoviesListManager {
    func responseHandling(responseData: Data, complition: (PackageOfMovies)->()) {
        do {
            let moviesPackage = try JSONDecoder().decode(PackageOfMovies.self, from: responseData)
            complition(moviesPackage)
        } catch let error {
            print(error)
        }
    }
}

class UpcomingListMoviesManager: MoviesListManager {
    lazy private var provider = MoyaProvider<MovieAPI>()
    
    func getMovies(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getUpcomingMovies(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.responseHandling(responseData: moyaResponse.data, complition: complition)
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

class PopularListMoviesManager: MoviesListManager {
    private lazy var provider = MoyaProvider<MovieAPI>()
    func getMovies(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getPopularMovies(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.responseHandling(responseData: moyaResponse.data, complition: complition)
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

class TopRatedListMoviesManager: MoviesListManager {
    private lazy var provider = MoyaProvider<MovieAPI>()
    func getMovies(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getTopRatedMovies(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.responseHandling(responseData: moyaResponse.data, complition: complition)
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

class NowPlayingListMoviesManager: MoviesListManager {
    private lazy var provider = MoyaProvider<MovieAPI>()
    func getMovies(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getNowPlayingMovies(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.responseHandling(responseData: moyaResponse.data, complition: complition)
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

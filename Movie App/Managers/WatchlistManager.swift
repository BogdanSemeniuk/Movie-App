//
//  WatchlistManager.swift
//  Movie App
//
//  Created by Bogdan on 08.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya
import CoreData

class WatchlistManager {
    lazy var provider = MoyaProvider<WatchlistAPI>()
    
    func getMoviesFromWatchlist(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getMoviesFromMyWatchlist(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let moviesPackage = try JSONDecoder().decode(PackageOfMovies.self, from: responseData)
                    complition(moviesPackage)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func saveMovies(movies: [Movie]) {
        for movie in movies {
            let entity = NSEntityDescription.entity(forEntityName: "MovieObj", in: CoreDataManager.context)
            let movieObject = MovieObj(entity: entity!, insertInto: CoreDataManager.context)
            movieObject.title = movie.title
            movieObject.overview = movie.overview
            if let genres = movie.genreIds {
                movieObject.genres = genres
            }
            movieObject.poster = movie.posterPath
            CoreDataManager.saveContext()
        }
    }
}

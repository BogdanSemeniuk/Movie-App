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
    private let fetchRequest: NSFetchRequest<MovieObj> = MovieObj.fetchRequest()
    
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
    
    private func deleteAllMovies() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try CoreDataManager.context.execute(batchDeleteRequest)
        } catch {
            print(error)
        }
    }
    
    func printAllMoviesInBase() {
        do {
            let allMovies = try CoreDataManager.context.fetch(fetchRequest) as [MovieObj]
            print("All movies: ")
            allMovies.forEach({ (movie) in
                print(movie.title!)
            })
        } catch {
            print(error)
        }
    }
    
    func updateBaseIfNeed(movies: [Movie]) {
        if moviesArentMatch(movies: movies) {
            deleteAllMovies()
            saveMovies(movies: movies)
        }
    }
    
    private func moviesArentMatch(movies: [Movie]) -> Bool {
        let arrayOfNames = movies.map { $0.title }
        do {
            let allMovies = try CoreDataManager.context.fetch(fetchRequest) as [MovieObj]
            if arrayOfNames.count != allMovies.count {
                return true
            }
            for movie in allMovies {
                if !arrayOfNames.contains(movie.title!) {
                    return true
                }
            }
        } catch {
            print(error)
        }
        return false
    }
    
    private func saveMovies(movies: [Movie]) {
        for movie in movies {
            let entity = NSEntityDescription.entity(forEntityName: "MovieObj", in: CoreDataManager.context)
            let movieObject = MovieObj(entity: entity!, insertInto: CoreDataManager.context)
            movieObject.title = movie.title
            movieObject.voteAverage = movie.voteAverage
            movieObject.voteCount = Int16(movie.voteCount)
            if let genres = movie.genreIds {
                movieObject.genres = genres
            }
            movieObject.poster = movie.posterPath
            CoreDataManager.saveContext()
        }
    }
}

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
    
    private func printAllMoviesInBase() {
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
    
    
    func updateBaseIfNeeded(moviesFromResponse movies: [Movie]) {
        let setIdFromBase = moviesIdFromBase()
        let setIdFromResponse = moviesIdFromResponse(moviesFromResponse: movies)
        
        if setIdFromBase != setIdFromResponse {
            removeExcessMoviesFromBase(moviesFromResponse: movies)
            let moviesToAdd = addMissingMoviesToBase(moviesFromResponse: movies)
            saveMoviesToBase(movies: moviesToAdd)
        }
    }
    
    private func addMissingMoviesToBase(moviesFromResponse movies: [Movie]) -> [Movie] {
        let setIdFromBase = moviesIdFromBase()
        
        var moviesToAdd = [Movie]()
        movies.forEach { (movie) in
            if !setIdFromBase.contains(movie.id) {
                moviesToAdd.append(movie)
            }
        }
        return moviesToAdd
    }
    
    private func removeExcessMoviesFromBase(moviesFromResponse movies: [Movie]) {
        let moviesFromBase = allMoviesInBase()
        
        let setIdFromResponse = moviesIdFromResponse(moviesFromResponse: movies)
        
        moviesFromBase.forEach { (movie) in
            if !setIdFromResponse.contains(Int(movie.id)) {
                CoreDataManager.context.delete(movie)
                CoreDataManager.saveContext()
            }
        }
    }
    
    private func moviesIdFromBase() -> Set<Int> {
        let moviesFromBase = allMoviesInBase()
        var moviesId: Set<Int> = []
        moviesFromBase.forEach({moviesId.insert(Int($0.id)) })
        return moviesId
    }
    
    private func moviesIdFromResponse(moviesFromResponse movies: [Movie]) -> Set<Int> {
        var moviesId: Set<Int> = []
        movies.forEach { moviesId.insert($0.id) }
        return moviesId
    }
    
    private func allMoviesInBase() -> [MovieObj] {
        var allMovies = [MovieObj]()
        do {
            allMovies = try CoreDataManager.context.fetch(fetchRequest) as [MovieObj]
        } catch {
            print(error)
        }
        return allMovies
    }
    
    private func saveMoviesToBase(movies: [Movie]) {
        for movie in movies {
            let entity = NSEntityDescription.entity(forEntityName: "MovieObj", in: CoreDataManager.context)
            let movieObject = MovieObj(entity: entity!, insertInto: CoreDataManager.context)
            movieObject.title = movie.title
            movieObject.voteAverage = movie.voteAverage
            movieObject.voteCount = Int32(movie.voteCount)
            if let genres = movie.genreIds {
                movieObject.genres = genres
            }
            movieObject.poster = movie.posterPath
            movieObject.id = Int32(movie.id)
            CoreDataManager.saveContext()
        }
    }
}

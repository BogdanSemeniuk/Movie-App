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
        do {
            let allMovies = try CoreDataManager.context.fetch(fetchRequest) as [MovieObj]
            allMovies.forEach({ (movie) in
                CoreDataManager.context.delete(movie)
            self.printAllMoviesInBase()
            })
        } catch {
            print(error)
        }
        printAllMoviesInBase()
        CoreDataManager.saveContext()
        printAllMoviesInBase()
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
        if moviesDontMatch(movies: movies) {
            deleteAllMovies()
            saveMovies(movies: movies)
        }
    }
    
    
    func updateBaseIfNeeded(moviesFromResponse movies: [Movie]) {
        var moviesIdFromResponse: Set<Int> = []
        movies.forEach { moviesIdFromResponse.insert($0.id) }
        
        var moviesIdFromBase: Set<Int> = []
        let allMoviesFromBase = allMoviesInBase()
        allMoviesFromBase.forEach({moviesIdFromBase.insert(Int($0.id)) })
        
        print("movies id from response \(moviesIdFromResponse)")
        print("movies id from CoreData \(moviesIdFromBase)")
        
        let commonMoviesId = moviesIdFromResponse.intersection(moviesIdFromBase)
        print("common movies id \(commonMoviesId)")
        
        allMoviesFromBase.forEach { (movie) in
            if !commonMoviesId.contains(Int(movie.id)) {
                CoreDataManager.context.delete(movie)
            }
        }
        CoreDataManager.saveContext()
        
        // добавить недостающие фильмы в базе с запроса
    }
    
    func allMoviesInBase() -> [MovieObj] {
        var allMovies = [MovieObj]()
        do {
            allMovies = try CoreDataManager.context.fetch(fetchRequest) as [MovieObj]
        } catch {
            print(error)
        }
        return allMovies
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func moviesDontMatch(movies: [Movie]) -> Bool {
        
        var moviesIdFromResponse: Set<Int> = []
        movies.forEach { moviesIdFromResponse.insert($0.id) }
        var moviesIdFromCoreData: Set<Int> = []
        
        do {
            let allMovies = try CoreDataManager.context.fetch(fetchRequest) as [MovieObj]
            allMovies.forEach({moviesIdFromCoreData.insert(Int($0.id)) })
        } catch {
            print(error)
        }
        return moviesIdFromResponse != moviesIdFromCoreData
    }
    
    private func saveMovies(movies: [Movie]) {
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

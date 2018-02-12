//
//  MovieManager.swift
//  Movie App
//
//  Created by Богдан Семенюк on 21.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya


class MovieManager {
    private lazy var provider = MoyaProvider<MovieAPI>()
    
    func getMovieDetails(id: Int, complition:@escaping (Movie) -> ()) {
        provider.request(.getMovieDetails(id: id)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let movieDetails = try JSONDecoder().decode(Movie.self, from: responseData)
                    complition(movieDetails)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func getMovieImages(id: Int, complition:@escaping (Images) -> ()) {
        provider.request(.getAllImages(id: id)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let images = try JSONDecoder().decode(Images.self, from: responseData)
                    complition(images)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func getMovieVideos(id: Int, complition:@escaping (Videos) -> ()) {
        provider.request(.getMovieTrailers(id: id)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let videos = try JSONDecoder().decode(Videos.self, from: responseData)
                    complition(videos)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func searchMovies(page: Int, query: String, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.searchMovies(page: page, query: query)) { (result) in
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
    
    func isWatchlistContainMovie(id: Int, complition:@escaping (MovieStatus) -> Void) {
        provider.request(.getMovieStatusInWatchlist(id: id)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let response = try JSONDecoder().decode(MovieStatus.self, from: responseData)
                    complition(response)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

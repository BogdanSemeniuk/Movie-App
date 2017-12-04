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
    
    func getUpcomingMovies(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getUpcomingMovies(page: page)) { (result) in
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
    
    func getMovieDetails(id: Int, complition:@escaping (MovieDetails) -> ()) {
        provider.request(.getMovieDetails(id: id)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: responseData)
                    complition(movieDetails)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

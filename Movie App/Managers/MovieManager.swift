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
    
    func getPopularMovies(page: Int, complition: @escaping (PackageOfMovies) -> ()) {
        provider.request(.getPopularMovies(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let moviesPackage = try JSONDecoder().decode(PackageOfMovies.self, from: responseData)
                    complition(moviesPackage)
                    //print(moviesPackage.results![0])
                } catch let error {
                    print(error)
                }
                

            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

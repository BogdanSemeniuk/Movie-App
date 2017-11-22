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
    
    func getPopularMovies(page: Int) {
        provider.request(.getPopularMovies(page: page)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let moviesPackage = try JSONDecoder().decode(PackageOfMovies.self, from: responseData)
                    print(moviesPackage.results![0])
                } catch let error {
                    print(error)
                }
                
                
//                let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
//                guard let unwrappedJson = responseJSON as? Dictionary<String, Any> else { return }
//                print(unwrappedJson)
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

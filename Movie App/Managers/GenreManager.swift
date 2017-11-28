//
//  GenreManager.swift
//  Movie App
//
//  Created by Богдан Семенюк on 28.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya

class GenreManager {
    private lazy var provider = MoyaProvider<GenreAPI>()
    
    func getGenres(complition: @escaping (GenresList) -> ()) {
        provider.request(.getAllGenre()) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                do {
                    let genresList = try JSONDecoder().decode(GenresList.self, from: responseData)
                    complition(genresList)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

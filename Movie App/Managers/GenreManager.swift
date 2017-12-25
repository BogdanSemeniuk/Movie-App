//
//  GenreManager.swift
//  Movie App
//
//  Created by Богдан Семенюк on 28.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya
import CoreData

class GenreManager {
    private lazy var provider = MoyaProvider<GenreAPI>()
    
    private func getGenres(complition: @escaping (GenresList) -> ()) {
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
    
    func updateIfNeeded() {
        if !genreStorageIsEmpty() {
            return
        }
        getGenres { (genres) in
            self.saveGanres(genres: genres.genres)
        }
    }
    
    private func genreStorageIsEmpty() -> Bool {
        let fetchRequest: NSFetchRequest<GenreObj> = GenreObj.fetchRequest()
        fetchRequest.fetchLimit = 1
        do {
            return try CoreDataManager.context.fetch(fetchRequest).count == 0
        } catch {
            return true
        }
    }
    
    private func saveGanres(genres: [Genre]) {
        for genre in genres {
            let entity = NSEntityDescription.entity(forEntityName: "GenreObj", in: CoreDataManager.context)
            let genreObject = GenreObj(entity: entity!, insertInto: CoreDataManager.context)
            genreObject.id = Int16(genre.id)
            genreObject.name = genre.name
            CoreDataManager.saveContext()
        }
    }
    
    func getGenreName(id: Int) -> String {
        let fetchRequest: NSFetchRequest<GenreObj> = GenreObj.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            return try CoreDataManager.context.fetch(fetchRequest).first?.name ?? ""
        } catch {
            return ""
        }
    }
}

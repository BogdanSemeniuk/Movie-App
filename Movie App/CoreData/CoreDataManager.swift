//
//  CoreDataManager.swift
//  Movie App
//
//  Created by Богдан Семенюк on 28.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    private init() {}
    
    let context = CoreDataStack.context
    
    // MARK: - Methods
    
    func storageIsEmpty() -> Bool {
        guard let objects = allObjectsInStorage() else {
            return true
        }
        if objects.isEmpty {
            return true
        }
        return false
    }
    
    func clearStorage()  {
        guard let objects = allObjectsInStorage() else {return}
        for object in objects {
            context.delete(object)
        }
        saveContext()
    }

    func saveGanres(genres: [Genre]) {
        for genre in genres {
            let entity = NSEntityDescription.entity(forEntityName: "GenreObj", in: context)
            let genreObject = NSManagedObject(entity: entity!, insertInto: context)
            genreObject.setValue(genre.id, forKey: "id")
            genreObject.setValue(genre.name, forKey: "name")
            saveContext()
        }
    }
    
    private func allObjectsInStorage() -> [NSManagedObject]? {
        
        var objects: [NSManagedObject]? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreObj")
        do {
            objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return objects
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getGenreNameWithId(id: Int) -> String {
        guard let objects = allObjectsInStorage() else {return "Storage is empty"}
        for obj in objects {
            guard let objId = obj.value(forKey: "id") as? Int else {return ""}
            if id == objId {
                guard let name = obj.value(forKey: "name") as? String else {return ""}
                return name
            }
        }
        return ""
    }
}


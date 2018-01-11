//
//  MovieObj+CoreDataProperties.swift
//  Movie App
//
//  Created by Bogdan on 11.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieObj> {
        return NSFetchRequest<MovieObj>(entityName: "MovieObj")
    }

    @NSManaged public var genres: [Int]?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Float
    @NSManaged public var voteCount: Int16

}

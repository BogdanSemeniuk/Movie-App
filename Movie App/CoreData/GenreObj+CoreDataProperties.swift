//
//  GenreObj+CoreDataProperties.swift
//  Movie App
//
//  Created by Богдан Семенюк on 03.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//
//

import Foundation
import CoreData


extension GenreObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreObj> {
        return NSFetchRequest<GenreObj>(entityName: "GenreObj")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}

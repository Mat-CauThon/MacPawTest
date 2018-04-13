//
//  Film+CoreDataProperties.swift
//  testProject
//
//  Created by Roman Mishchenko on 12.04.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var genre: String?
    @NSManaged public var info: String?
    @NSManaged public var poster: NSData?
    @NSManaged public var title: String?
    @NSManaged public var year: Int16
    @NSManaged public var searchBool: Bool

}

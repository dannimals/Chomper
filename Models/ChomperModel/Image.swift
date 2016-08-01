//
//  Image.swift
//  Chomper
//
//  Created by Danning Ge on 8/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreData
import CoreLocation


public final class Image: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public var createdAt: NSDate
    @NSManaged public var url: String
    

    // MARK: - Relationships
    
    @NSManaged public var list: List?
    @NSManaged public var place: Place?
    @NSManaged public var user: User?

    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, url: String, createdAt: NSDate) -> Image {
        let image: Image = moc.insertObject()
        image.url = url
        image.createdAt = createdAt
        return image
    }
}

extension Image: ManagedObjectType {
    public static var entityName: String {
        return "Image"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "createdAt", ascending: false)]
    }
}


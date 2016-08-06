//
//  Image.swift
//  Chomper
//
//  Created by Danning Ge on 8/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
import CoreLocation


public final class Image: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public var createdAt: NSDate
    @NSManaged public private(set) var id: String
    @NSManaged public var imageData: NSData
    @NSManaged public var thumbData: NSData?


    // MARK: - Relationships
    
    @NSManaged public var list: List?
    @NSManaged public var place: Place?
    @NSManaged public var user: User?

    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, createdAt: NSDate = NSDate(), imageData: NSData, thumbData: NSData?) -> Image {
        let image: Image = moc.insertObject()
        image.id = NSUUID().UUIDString
        image.createdAt = createdAt
        image.imageData = imageData
        image.thumbData = thumbData
        return image
    }
    
    static func findOrCreateImage(id: String, imageData: NSData, inContext moc: NSManagedObjectContext) -> Image {
        let predicate = NSPredicate(format: "id == %@", id)
        let image = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.imageData = imageData; $0.id = id }
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


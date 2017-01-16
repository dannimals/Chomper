//
//  Notifications.swift
//  Chomper
//
//  Created by Danning Ge on 6/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

//
// Adapted from "objc Core Data" book by Florian Kugler and Daneil Eggert
// https://www.objc.io/books/core-data/

import CoreData
import Foundation

public struct ObjectsDidChangeNotification {
    
    // MARK: Used to observe changes on an entity object from an NSNotification
    
    fileprivate let notification: Notification
    public var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    public init(note: Notification) {
        assert(note.name == NSNotification.Name.NSManagedObjectContextObjectsDidChange)
        notification = note
    }
    
    public var insertedObjects: Set<ManagedObject> {
        return objectsForKey(NSInsertedObjectsKey)
    }
    
    public var deletedObjects: Set<ManagedObject> {
        return objectsForKey(NSDeletedObjectsKey)
    }
    
    public var updatedObjects: Set<ManagedObject> {
        return objectsForKey(NSUpdatedObjectsKey)
    }
    
    public var refreshedObjects: Set<ManagedObject> {
        return objectsForKey(NSRefreshedObjectsKey)
    }
    
    public var invalidatedObjects: Set<ManagedObject> {
        return objectsForKey(NSInvalidatedObjectsKey)
    }
    
    public var invalidatedAllObjects: Bool {
        return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    public var allObjects: Set<ManagedObject> {
        var allObjects = Set<ManagedObject>()
        allObjects = allObjects.union(insertedObjects)
        allObjects = allObjects.union(deletedObjects)
        allObjects = allObjects.union(updatedObjects)

        return allObjects
    }
    
    fileprivate func objectsForKey(_ key: String) -> Set<ManagedObject> {
        return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
    }
}

//
//  Notifications.swift
//  Chomper
//
//  Created by Danning Ge on 6/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
import Foundation

public struct ObjectsDidChangeNotification {
    
    // MARK: Used to observe changes on an entity object from an NSNotification
    
    private let notification: NSNotification
    public var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    init(note: NSNotification) {
        assert(note.name == NSManagedObjectContextObjectsDidChangeNotification)
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
    
    private func objectsForKey(key: String) -> Set<ManagedObject> {
        return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
    }
}

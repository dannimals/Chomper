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
    
    // MARK: Used to observe changes on entity object 
    
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

extension NSManagedObjectContext {
    
    // MARK: Adds the given block to the default `NSNotificationCenter`'s dispatch table for the given context's objects-did-change notifications. Returns an opaque object to act as the observer. This must be sent to the default `NSNotificationCenter`'s `removeObserver()`.
    
    public func addObjectsDidChangeNotificationObserver(handler: ObjectsDidChangeNotification -> ()) -> NSObjectProtocol {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: self, queue: nil) { note in
            let wrappedNote = ObjectsDidChangeNotification(note: note)
            handler(wrappedNote)
        }
    }
}
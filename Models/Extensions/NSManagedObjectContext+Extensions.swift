//
//  NSManagedObjectContext+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/6/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    
    //
    // Convenience method for accessing global main context, used for UI
    
    public static func mainContext() -> NSManagedObjectContext {
        let mainContext = createChomperMainContext
        return mainContext
    }
    
    //
    // Convenience method for creating background context
    // Must be used with mainContext as receiver 
    
    public func createBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }
    
    
    public func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    
    public func performChanges(block: () -> ()) {
        performBlock {
            block()
            self.saveOrRollback()
        }
    }
    
    //
    // Returns an NSNotification NSManagedObjectContextDidSaveNotification observer on the source managed object context's save()
    // Handles ObjectsDidChangeNotification as callback
    
    public func addObjectsDidChangeNotificationObserver(handler: ObjectsDidChangeNotification -> ()) -> NSObjectProtocol {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(NSManagedObjectContextDidSaveNotification, object: self, queue: nil) { note in
            let wrappedNote = ObjectsDidChangeNotification(note: note)
            handler(wrappedNote)
        }
    }
    
    //
    // Adds an NSNotification NSManagedObjectContextDidSaveNotification observer on the source managed object context's save()
    // And saves the changes from merge on target context

    public func addNSManagedObjectContextDidSaveNotificationObserver(targetContext: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: self, queue: nil) { note in
            targetContext.performChanges {
                targetContext.mergeChangesFromContextDidSaveNotification(note)
            }
        }
    }
}
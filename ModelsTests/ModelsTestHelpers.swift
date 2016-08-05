//
//  ModelsTestHelpers.swift
//  Chomper
//
//  Created by Danning Ge on 8/4/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
@testable import Models

let tempURL = NSURL.documentsDirectory.URLByAppendingPathComponent("Chomper.modelTest")

//
// Create a SQLite store context for unit testing
func setupTestingManagedContext() -> NSManagedObjectContext {
    let model = NSManagedObjectModel.mergedModelFromBundles([NSBundle(forClass: Place.self)])
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model!)
    do {
        try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: tempURL, options: nil)
    } catch let error as NSError {
        handlePSCError(psc, model: model!, error: error)
    }
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = psc
    return moc
}
		
func handlePSCError(psc: NSPersistentStoreCoordinator, model: NSManagedObjectModel, error: NSError) -> NSPersistentStoreCoordinator? {
    if error.domain == NSCocoaErrorDomain {
        #if DEBUG
            let stores = psc.persistentStores
            for store in stores {
                try! psc.removePersistentStore(store)
            }
            try! NSFileManager.defaultManager().removeItemAtURL(tempURL)
            let newPsc = NSPersistentStoreCoordinator(managedObjectModel: model)
            try! newPsc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: tempURL, options: nil)
            
            return newPsc
        #endif
    }
    return nil
}

extension NSManagedObjectContext {
    
    //
    // Synchronous performChanges on context
    func performChangesAndWait(block: () -> Void) {
        performBlockAndWait{
            block()
            try! self.save()
        }
    }
}
//
//  ModelsTestHelpers.swift
//  Chomper
//
//  Created by Danning Ge on 8/4/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
@testable import Models

//
// Create an in-memory context for unit testing
func setupTestingManagedContext() -> NSManagedObjectContext {
    let tempURL = NSURL.documentsDirectory.URLByAppendingPathComponent("Chomper.modelTest")
    let model = NSManagedObjectModel.mergedModelFromBundles([NSBundle(forClass: Place.self)])
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model!)
    do {
        try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: tempURL, options: nil)
    } catch {
        print("adding in-memory test MOC failed")
    }
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = psc
    return moc
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
//
//  ChomperStack.swift
//  Chomper
//
//  Created by Danning Ge on 7/6/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData

private let StoreURL = NSURL.documentsDirectory.URLByAppendingPathComponent("Chomper.chomper")

//
// Global var for returning the main NSManagedObjectContext

var createChomperMainContext: NSManagedObjectContext = {
    let bundles = [NSBundle(forClass: Place.self)]
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else { fatalError("Model not found!") }
    var psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    do {
        try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
    } catch let error as NSError {
        psc = handlePSCError(psc, model: model, error: error)!
    }
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}()

//
// Blow out Core Data in simulator if there are version conflicts

func handlePSCError(psc: NSPersistentStoreCoordinator, model: NSManagedObjectModel, error: NSError) -> NSPersistentStoreCoordinator? {
    if error.domain == NSCocoaErrorDomain {
        #if DEBUG
            if NSFileManager.defaultManager().fileExistsAtPath(StoreURL.path!) {
                try! psc.destroyPersistentStoreAtURL(StoreURL, withType: NSSQLiteStoreType, options: nil)
            }
            try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
            return psc
        #endif
    }
    return nil
    
    // TODO: migration
}
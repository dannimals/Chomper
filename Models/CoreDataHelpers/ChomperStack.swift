//
//  ChomperStack.swift
//  Chomper
//
//  Created by Danning Ge on 7/6/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData

private let StoreURL = URL.documentsDirectory.appendingPathComponent("Chomper.chomper")

//
// Global var for returning the main NSManagedObjectContext

var createChomperMainContext: NSManagedObjectContext = {
    let bundles = [Bundle(for: Place.self)]
    guard let model = NSManagedObjectModel.mergedModel(from: bundles) else { fatalError("Model not found!") }
    var psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    do {
        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: StoreURL, options: nil)
    } catch let error as NSError {
        psc = handlePSCError(psc, model: model, error: error)!
    }
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}()

//
// Blow out Core Data in simulator if there are version conflicts

func handlePSCError(_ psc: NSPersistentStoreCoordinator, model: NSManagedObjectModel, error: NSError) -> NSPersistentStoreCoordinator? {
    if error.domain == NSCocoaErrorDomain {
        #if DEBUG
            if FileManager.default.fileExists(atPath: StoreURL.path) {
                try! psc.destroyPersistentStore(at: StoreURL, ofType: NSSQLiteStoreType, options: nil)
            }
            try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: StoreURL, options: nil)
            return psc
        #endif
    }
    return nil
    
    // TODO: migration
}

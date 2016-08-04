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
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}()

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
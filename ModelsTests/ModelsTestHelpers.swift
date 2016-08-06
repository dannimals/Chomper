//
//  ModelsTestHelpers.swift
//  Chomper
//
//  Created by Danning Ge on 8/4/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
@testable import Models

extension NSManagedObjectContext {
    
    static func chomperInMemoryTestContext() -> NSManagedObjectContext {
        return chomperTestContext { $0.addInMemoryTestStore() }
    }
    
    static func chomperSQLiteTestContext() -> NSManagedObjectContext {
        return chomperTestContext { $0.addSQLiteTestStore() }
    }
    
    static func chomperTestContext(addStore: NSPersistentStoreCoordinator -> ()) -> NSManagedObjectContext {
        // TODO: refactor later after versioning
        let model = NSManagedObjectModel.mergedModelFromBundles([NSBundle(forClass: Place.self)])!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        addStore(coordinator)
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
    //
    // Synchronous performChanges on context
    func performChangesAndWait(block: () -> Void) {
        performBlockAndWait{
            block()
            try! self.save()
        }
    }
}

extension NSPersistentStoreCoordinator {
    
    func addInMemoryTestStore() {
        try! addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
    }
    
    func addSQLiteTestStore() {
        let storeURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).URLByAppendingPathComponent("Chomper.modelTest")
        if NSFileManager.defaultManager().fileExistsAtPath(storeURL.path!) {
            try! destroyPersistentStoreAtURL(storeURL, withType: NSSQLiteStoreType, options: nil)
        }
        try! addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
    }
}


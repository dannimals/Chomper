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
    
    static func chomperTestContext(_ addStore: (NSPersistentStoreCoordinator) -> ()) -> NSManagedObjectContext {
        // TODO: refactor later after versioning
        let model = NSManagedObjectModel.mergedModelFromBundles([Bundle(forClass: Place.self)])!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        addStore(coordinator)
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
    //
    // Synchronous performChanges on context
    func performChangesAndWait(_ block: @escaping () -> Void) {
        performAndWait{
            block()
            try! self.save()
        }
    }
}

extension NSPersistentStoreCoordinator {
    
    func addInMemoryTestStore() {
        try! addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    }
    
    func addSQLiteTestStore() {
        let storeURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("Chomper.modelTest")
        if FileManager.default.fileExists(atPath: storeURL.path) {
            try! destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
        }
        try! addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    }
}


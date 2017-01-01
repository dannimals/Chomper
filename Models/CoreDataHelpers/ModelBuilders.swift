//
//  ModelBuilders.swift
//  Chomper
//
//  Created by Danning Ge on 5/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

open class ManagedObject: NSManagedObject {
    //
    // All model entity classes must subclass ManagedObject
}

public protocol ManagedObjectType: class {
    //
    // All model entity classes must implement ManagedObjectType
    
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var defaultPredicate: NSPredicate { get }
    var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType {
    //
    // Default implementation of ManagedObjectType
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static var defaultPredicate: NSPredicate {
        return NSPredicate()
    }
}

extension ManagedObjectType where Self: ManagedObject {
    public static func findOrCreateInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        guard let obj = findOrFetchInContext(moc, matchingPredicate: predicate) else {
            let newObj: Self = moc.insertObject()
            configure(newObj)
            return newObj
        }
        return obj
    }
    
    public static func findOrFetchInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate) else {
            return fetchInContext(moc) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return obj
    }
    
    public static func fetchInContext(_ context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Self.entityName)
        configurationBlock(request)
        guard let result = try! context.fetch(request) as? [Self] else { fatalError("Fetched objects have wrong type") }
        return result
    }
    
    public static func materializedObjectInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in moc.registeredObjects where !obj.isFault {
            guard let obj = obj as? Self, predicate.evaluate(with: obj) else { continue }
            return obj
        }
        return nil
    }
}


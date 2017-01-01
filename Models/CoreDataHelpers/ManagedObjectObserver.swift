//
//  ManagedObjectObserver.swift
//  Chomper
//
//  Created by Danning Ge on 5/22/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

//
// Adapted from "objc Core Data" book by Florian Kugler and Daneil Eggert
// https://www.objc.io/books/core-data/

public enum ChangeType {
    case delete
    case update
}

public final class ManagedObjectObserver {
    
    // MARK: Properties
    
    fileprivate var token: NSObjectProtocol!
    fileprivate var objectHasBeenDeleted: Bool = false
    
    
    public init?(object: ManagedObjectType, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        objectHasBeenDeleted = !type(of: object).defaultPredicate.evaluate(with: object)
        token = moc.addObjectsDidChangeNotificationObserver { [unowned self] note in
            guard let changeType = self.changeTypeOfObject(object, inNotification: note) else { return }
            self.objectHasBeenDeleted = changeType == .delete
            changeHandler(changeType)
        }
    }

    
    fileprivate func changeTypeOfObject(_ object: ManagedObjectType, inNotification note:ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.containsObjectIdenticalTo(object) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.containsObjectIdenticalTo(object) {
            let predicate = type(of: object).defaultPredicate
            if predicate.evaluate(with: object) {
                return .update
            } else if !objectHasBeenDeleted {
                return .delete
            }
        }
        return nil
    }

    deinit {
        NotificationCenter.default.removeObserver(token)
    }
}

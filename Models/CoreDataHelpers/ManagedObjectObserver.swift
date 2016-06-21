//
//  ManagedObjectObserver.swift
//  Chomper
//
//  Created by Danning Ge on 5/22/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
import Foundation

public enum ChangeType {
    case Delete
    case Update
}

public final class ManagedObjectObserver {
    
    // MARK: Properties
    
    private var token: NSObjectProtocol!
    private var objectHasBeenDeleted: Bool = false
    
    
    public init?(object: ManagedObjectType, changeHandler: ChangeType -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        objectHasBeenDeleted = !object.dynamicType.defaultPredicate.evaluateWithObject(object)
        token = moc.addObjectsDidChangeNotificationObserver { [unowned self] note in
            guard let changeType = self.changeTypeOfObject(object, inNotification: note) else { return }
            self.objectHasBeenDeleted = changeType == .Delete
            changeHandler(changeType)
        }
    }

    
    private func changeTypeOfObject(object: ManagedObjectType, inNotification note:ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.containsObjectIdenticalTo(object) {
            return .Delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.containsObjectIdenticalTo(object) {
            let predicate = object.dynamicType.defaultPredicate
            if predicate.evaluateWithObject(object) {
                return .Update
            } else if !objectHasBeenDeleted {
                return .Delete
            }
        }
        return nil
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(token)
    }
}
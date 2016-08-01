//
//  User.swift
//  Chomper
//
//  Created by Danning Ge on 8/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreData
import CoreLocation


public final class User: ManagedObject {
   
    // MARK: - Properties
    
    @NSManaged public var email: String
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

    
    // MARK: - Relationships
    
    @NSManaged public var favoriteLists: Set<List>?
    @NSManaged public var friends: Set<User>?
    @NSManaged public var lists: Set<List>?
    @NSManaged public var profileImage: Image?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, email: String, firstName: String? = nil, lastName: String? = nil) -> User {
        let user: User = moc.insertObject()
        user.email = email
        user.firstName = firstName
        user.lastName = lastName
        return user
    }
    
    static func findOrCreateUser(email: String, inContext moc: NSManagedObjectContext) -> User? {
        guard !email.isEmpty else { return nil }
        let predicate = NSPredicate(format: "email == %@", email)
        let user = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.email = email }
        return user
    }
}

extension User: ManagedObjectType {
    public static var entityName: String {
        return "User"
    }
}


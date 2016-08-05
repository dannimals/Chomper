
import Foundation
import CoreData


public final class List: ManagedObject {
    
    // MARK: - Properties

    @NSManaged public var name: String
    //
    // Only used for default "Saved" list
    // "Saved" list sequence num is set to 1
    @NSManaged public var sequenceNum: NSNumber?

    
    // MARK: - Relationships
    
    @NSManaged public var image: Image?
    @NSManaged public var favoritedUsers: Set<User>?
    @NSManaged public var owner: User?
    @NSManaged public var places: Set<Place>?

    public override func prepareForDeletion() {
        //
        // Delete Places that are only associated with this List
        if let places = places {
            for place in places {
                if place.lists?.count == 1 {
                    managedObjectContext?.deleteObject(place)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, name: String, ownerEmail: String) -> List {
        guard let owner = User.findOrCreateUser(ownerEmail, inContext: moc) else { fatalError("Cannot create user") }
        let list: List = moc.insertObject()
        list.name = name
        list.owner = owner
        return list
    }
    
    static func findOrCreateList(name: String, inContext moc: NSManagedObjectContext) -> List? {
        guard !name.isEmpty else { return nil }
        let predicate = NSPredicate(format: "name == %@", name)
        let list = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.name = name}
        return list
    }
}

extension List: ManagedObjectType {
    public static var entityName: String {
        return "List"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}


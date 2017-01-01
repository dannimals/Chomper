import Common
import CoreData


public final class List: ManagedObject {
    
    // MARK: - Properties

    @NSManaged public var name: String

    //
    // Only used for default "Saved" list
    // "Saved" list sequence num is set to 1
    @NSManaged public var sequenceNum: NSNumber?
    
    // MARK: - Relationships
    
    @NSManaged public var favoritedUsers: Set<User>?
    @NSManaged public var owner: User
    @NSManaged public var listPlaces: Set<ListPlace>?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(_ moc: NSManagedObjectContext, name: String, ownerEmail: String) -> List {
        guard let owner = User.findOrCreateUser(ownerEmail, inContext: moc) else { fatalError("Cannot create user") }
        let list: List = moc.insertObject()
        list.name = name
        list.owner = owner
        return list
    }
    
    static func findOrCreateList(_ name: String, ownerId: String, inContext moc: NSManagedObjectContext) -> List? {
        guard !name.isEmpty else { return nil }
        let predicate = NSPredicate(format: "name == %@ && owner.email == %@", name, ownerId)
        let list = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.name = name; $0.owner = User.findOrCreateUser(ownerId, inContext: moc)!}
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


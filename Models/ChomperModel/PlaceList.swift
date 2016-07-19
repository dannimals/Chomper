
import Foundation
import CoreData


public final class PlaceList: ManagedObject {
    
    // MARK: - Properties

    @NSManaged public var name: String
    @NSManaged public var updatedAt: NSDate?
    //
    // Only used for default "Saved" list
    // "Saved" list sequence num is set to 1
    @NSManaged public var sequenceNum: NSNumber?

    
    // MARK: - Relationships
    
    @NSManaged public var places: Set<Place>?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, name: String, updatedAt: NSDate?) -> PlaceList {
        let placeList: PlaceList = moc.insertObject()
        placeList.name = name
        placeList.updatedAt = updatedAt ?? NSDate()
        return placeList
    }
    
    static func findOrCreatePlaceList(name: String, inContext moc: NSManagedObjectContext) -> PlaceList? {
        guard !name.isEmpty else { return nil }
        let predicate = NSPredicate(format: "name == %@", name)
        let placeList = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.updatedAt = NSDate() }
        return placeList
    }
}

extension PlaceList: ManagedObjectType {
    public static var entityName: String {
        return "PlaceList"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}


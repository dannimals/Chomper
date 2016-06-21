
import Foundation
import CoreData


public final class PlaceList: ManagedObject {
    
    // MARK: - Properties

    @NSManaged public var name: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var numberOfPlaces: NSNumber?
    
    // MARK: - Relationships
    
    @NSManaged public var places: Set<Place>?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, name: String, updatedAt: NSDate?) -> PlaceList {
        let placeList: PlaceList = moc.insertObject()
        placeList.name = name
        placeList.updatedAt = updatedAt
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


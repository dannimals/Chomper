import Common
import CoreData
import CoreLocation


public final class Place: ManagedObject {
    
    // MARK: - Properties

    @NSManaged public var category: String?
    @NSManaged public var city: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var name: String
    @NSManaged public var neighborhood: String?
    @NSManaged public var phone: String?
    @NSManaged public var remoteId: String
    @NSManaged public var streetName: String?
    @NSManaged public var state: String?
    @NSManaged public var visited: NSNumber?
    @NSManaged public var zipcode: String?

    // Transient property - Do NOT access directly
    @NSManaged public var ownerId: String?
    
    // MARK: - Relationships

    @NSManaged public var listPlaces: Set<ListPlace>?
    @NSManaged public var owner: User
    
    
    // MARK: - Helpers
    
    //
    // Every time a new place is created, the ownerUserEmail in AppData will be automatically associated with it
    public static func insertIntoContext(_ moc: NSManagedObjectContext, category: String? = nil, city: String? = nil, location: CLLocation?, name: String, neighborhood: String? = nil, ownerId: String? = AppData.sharedInstance.ownerUserEmail, remoteId: String, streetName: String?, state: String?, visited: NSNumber? = NSNumber(value: false as Bool), zipcode: String? = nil, listPlaces: [String]) -> Place {
        
        let place: Place = moc.insertObject()
        place.city = city
        if let coord = location?.coordinate {
            place.latitude = coord.latitude as NSNumber?
            place.longitude = coord.longitude as NSNumber?
        }
        
        place.category = category
        place.neighborhood = neighborhood
        place.name = name
        place.ownerId = ownerId // Transient property
        place.remoteId = remoteId
        place.streetName = streetName
        place.state = state
        place.visited = visited
        place.zipcode = zipcode
        
        for listPlace in listPlaces {
            let listPlace = ListPlace.findOrCreateListPlace(remoteId, listName: listPlace, inContext: moc)
            place.listPlaces?.insert(listPlace)
        }
        
        place.owner = User.findOrCreateUser(ownerId!, inContext: moc)!
        
        return place
    }
    
    public static func addToLists(_ moc: NSManagedObjectContext, placeId: String, name: String, listPlaces: [String]) -> Place? {
        let place = Place.findOrCreatePlace(placeId, name: name, inContext: moc)
        
        for listPlace in listPlaces {
            let list = ListPlace.findOrCreateListPlace(placeId, listName: listPlace, inContext: moc)
            place?.listPlaces?.insert(list)
        }
        return place
    }
    
    public static func findOrCreatePlace(_ remoteId: String, name: String, inContext moc: NSManagedObjectContext) -> Place? {
        guard !remoteId.isEmpty else { return nil }

        let predicate = NSPredicate(format: "remoteId == %@", remoteId)
        let place = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.remoteId = remoteId; $0.name = name }
        return place
    }

}

extension Place: ManagedObjectType {
    
    public static var entityName: String {
        return "Place"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}

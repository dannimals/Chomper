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
    @NSManaged public var notes: String?
    @NSManaged public var phone: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var remoteId: String
    @NSManaged public var streetName: String?
    @NSManaged public var state: String?
    @NSManaged public var visited: NSNumber?
    @NSManaged public var zipcode: String?

    // Transient property - Do NOT access directly
    @NSManaged public var ownerId: String?
    
    // MARK: - Relationships

    @NSManaged public var images: Set<Image>?
    @NSManaged public var lists: Set<List>?
    @NSManaged public var owner: User
    
    public override func prepareForDeletion() {
        //
        // Delete Images that are only associated with this Place
        // i.e. image is associated with a profile or list
        if let images = images {
            for image in images {
                if image.user == nil && image.list == nil {
                    managedObjectContext?.deleteObject(image)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    //
    // Every time a new place is created, the ownerUserEmail in AppData will be automatically associated with it
    public static func insertIntoContext(moc: NSManagedObjectContext, category: String? = nil, city: String? = nil, location: CLLocation?, name: String, neighborhood: String?, notes: String? = nil, ownerId: String? = AppData.sharedInstance.ownerUserEmail, price: NSNumber?, rating: NSNumber?, remoteId: String, streetName: String?, state: String?, visited: NSNumber? = NSNumber(bool: false), zipcode: String? = nil, listNames: [String]) -> Place {
        
        let place: Place = moc.insertObject()
        place.city = city
        if let coord = location?.coordinate {
            place.latitude = coord.latitude
            place.longitude = coord.longitude
        }
        
        place.category = category
        place.name = name
        place.neighborhood = neighborhood
        place.notes = notes
        place.ownerId = ownerId // Transient property
        place.price = price
        place.rating = rating
        place.remoteId = remoteId
        place.streetName = streetName
        place.state = state
        place.visited = visited
        place.zipcode = zipcode
        
        for listName in listNames {
            if let list = List.findOrCreateList(listName, ownerId: ownerId!, inContext: moc) {
                place.lists?.insert(list)
            }
        }
        
        place.owner = User.findOrCreateUser(ownerId!, inContext: moc)!
        
        return place
    }
    
    public static func addToLists(moc: NSManagedObjectContext, remoteId: String, name: String, listNames: [String]) -> Place? {
        let place = Place.findOrCreatePlace(remoteId, name: name, inContext: moc)
        
        for name in listNames {
            if let list = List.findOrCreateList(name, ownerId: ownerEmail, inContext: moc) {
                place?.lists?.insert(list)
            }
        }
        return place
    }
    
    public static func findOrCreatePlace(remoteId: String, name: String, inContext moc: NSManagedObjectContext) -> Place? {
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
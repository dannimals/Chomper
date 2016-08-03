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

    
    // MARK: - Relationships

    @NSManaged public var lists: Set<List>?
    @NSManaged public var images: Set<Image>?
    
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
    
    public static func insertIntoContext(moc: NSManagedObjectContext, category: String? = nil, city: String? = nil, location: CLLocation?, name: String, neighborhood: String?, notes: String? = nil, price: NSNumber?, rating: NSNumber?, remoteId: String, streetName: String?, state: String?, visited: NSNumber? = NSNumber(bool: false), zipcode: String? = nil, listNames: [String]) -> Place {
        
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
        place.price = price
        place.rating = rating
        place.streetName = streetName
        place.state = state
        place.visited = visited
        place.zipcode = zipcode
        
        for listName in listNames {
            if let list = List.findOrCreateList(listName, inContext: moc) {
                place.lists?.insert(list)
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
import CoreData
import CoreLocation
import Foundation


public final class Place: ManagedObject {
    
    // MARK: - Properties

    @NSManaged public var city: String?
    @NSManaged public var creatorId: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var streetName: String?
    @NSManaged public var state: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var visited: NSNumber?
    @NSManaged public var zipcode: String?

    
    // MARK: - Relationships

    @NSManaged public var placeList: ManagedObject?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, city: String? = nil, creatorId: String? = nil, location: CLLocation?, name: String, notes: String? = nil, price: NSNumber? = nil, rating: NSNumber? = nil, streetName: String? = nil, state: String? = nil, updatedAt: NSDate? = nil, visited: NSNumber? = NSNumber(bool: false), zipcode: String? = nil, placeListName: String) -> Place {
        let place: Place = moc.insertObject()
        place.city = city
        place.creatorId = creatorId
        if let coord = location?.coordinate {
            place.latitude = coord.latitude
            place.longitude = coord.longitude
        }
        place.name = name
        place.notes = notes
        place.price = price
        place.rating = rating
        place.streetName = streetName
        place.state = state
        place.updatedAt = updatedAt
        place.visited = visited
        place.zipcode = zipcode

        place.placeList = PlaceList.findOrCreatePlaceList(placeListName, inContext: moc)
   
        return place
    }

}

extension Place: ManagedObjectType {
    
    public static var entityName: String {
        return "Place"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedDate", ascending: false)]
    }
}
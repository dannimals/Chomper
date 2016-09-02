import Common
import CoreData
import CoreLocation

public final class ListPlace: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public var downloadImageUrl: String?
    @NSManaged public var listImageId: String?
    @NSManaged public var listName: String
    @NSManaged public var placeId: String
    @NSManaged public var placeImageId: String?
    @NSManaged public var placeName: String
    @NSManaged public var price: NSNumber?
    @NSManaged public var notes: String?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var userRated: NSNumber?
    @NSManaged public var userPriced: NSNumber?
    

    // MARK: - Relationships
    
    @NSManaged public var place: Place?
    @NSManaged public var list: List?
    @NSManaged public var images: Set<Image>?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, address: String?, city: String?,  downloadImageUrl: String?, listName: String, location: CLLocation, phone: String?, placeId: String, placeName: String, price: NSNumber?, notes: String?, rating: NSNumber?, state: String?, userRated: Bool? = false, userPriced: Bool? = false) -> ListPlace {
        let listPlace: ListPlace = moc.insertObject()
        
        listPlace.downloadImageUrl = downloadImageUrl
        listPlace.listImageId = downloadImageUrl
        listPlace.listName = listName
        listPlace.notes = notes
        listPlace.placeId = placeId
        listPlace.placeName = placeName
        listPlace.price = price
        listPlace.rating = rating
        listPlace.userRated = NSNumber(bool: userRated!)
        listPlace.userPriced = NSNumber(bool: userPriced!)
        
        if let place = Place.findOrCreatePlace(placeId, name: placeName, inContext: moc) {
            place.streetName = place.streetName ?? address
            place.city = place.city ?? city
            place.phone = place.phone ?? phone
            place.state = place.state ?? state
            place.latitude = place.latitude ?? location.coordinate.latitude
            place.longitude = place.longitude ?? location.coordinate.longitude
            
            listPlace.place = place
        }
        
        if let list = List.findOrCreateList(listName, ownerId: AppData.sharedInstance.ownerUserEmail, inContext: moc) {
            listPlace.list = list
        }
        
        return listPlace
    }
    
    public static func findOrCreateListPlace(placeId: String, listName: String, inContext moc: NSManagedObjectContext) -> ListPlace {
        let predicate = NSPredicate(format: "placeId == %@ && listName == %@", placeId, listName)
        let listPlace = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.listName = listName; $0.placeId = placeId }
        return listPlace
    }
}

extension ListPlace: ManagedObjectType {
    public static var entityName: String {
        return "ListPlace"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "listName", ascending: false)]
    }
}

extension ListPlace: PlaceDetailsObjectProtocol {
    
    public var address: String? {
        get {
            return place?.streetName
        }
        set {
            self.address = newValue
        }
    }
    public var city: String? {
        get {
            return place?.city
        }
        set {
            self.city = newValue
        }
    }
    public var imageUrl: String? {
        get {
            return downloadImageUrl
        }
        set {
            self.downloadImageUrl = newValue
        }
    }
    public var location: CLLocation  {
        get {
            return CLLocation(latitude: CLLocationDegrees(place?.latitude ?? 0), longitude: CLLocationDegrees(place?.longitude ?? 0))
        }
    }
    public var name: String {
        get {
            return place?.name ?? ""
        }
    }
    public var phone: String? {
        get {
            return place?.phone
        }
        set {
            self.phone = newValue
        }
    }
    public var priceValue: Double? {
        get {
            return Double(price ?? 0)
        }
        set {
            self.priceValue = newValue
        }
    }
    public var ratingValue: Double? {
        get {
            return Double(rating ?? 0)
        }
        set {
            self.ratingValue = newValue
        }
    }
    public var state: String? {
        get {
            return place?.state
        }
        set {
            self.state = newValue
        }
    }
    public var type: String {
        get {
            return "\(ListPlace.self)"
        }
    }
    public var userPrice: NSNumber? {
        get {
            return userPriced
        }
        set {
            self.userPrice = newValue
        }
    }
    public var userRate: NSNumber? {
        get {
            return userRated
        }
        set {
            self.userRate = newValue
        }
    }
    public var userNotes: String? {
        get {
            return notes
        }
        set {
            self.notes = newValue
        }
    }
    public var venueId: String {
        get {
            return placeId
        }
    }
}








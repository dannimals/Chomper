import Common
import CoreData
import CoreLocation

public final class ListPlace: ManagedObject, PlaceDetailsObjectProtocol {
    
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
    
    // MARK: - PlaceDetailsObjectProtocol properties
    
    public var address: String?
    public var city: String?
    public var location = CLLocation(latitude: 0, longitude: 0)
    public var name = ""
    public var phone: String?
    public var imageUrl: String?
    public var priceValue: Double?
    public var ratingValue: Double?
    public var state: String?
    public var type = "\(ListPlace.self)"
    public var userPrice: NSNumber?
    public var userRate: NSNumber?
    public var userNotes: String?
    public var venueId = ""
    

    // MARK: - Relationships
    
    @NSManaged public var place: Place?
    @NSManaged public var list: List?
    @NSManaged public var images: Set<Image>?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, address: String?, city: String?,  downloadImageUrl: String?, listName: String, location: CLLocation, phone: String?, placeId: String, placeName: String, price: NSNumber?, notes: String?, rating: NSNumber?, state: String?, userRated: Bool? = false, userPriced: Bool? = false) -> ListPlace {
        let listPlace: ListPlace = moc.insertObject()
        
        listPlace.address = address
        listPlace.city = city
        listPlace.downloadImageUrl = downloadImageUrl
        listPlace.imageUrl = downloadImageUrl
        listPlace.location = location
        listPlace.listImageId = downloadImageUrl
        listPlace.listName = listName
        listPlace.notes = notes
        listPlace.phone = phone
        listPlace.placeName = placeName
        listPlace.placeId = placeId
        listPlace.placeName = placeName
        listPlace.price = price
        listPlace.priceValue = Double(price ?? 0)
        listPlace.rating = rating
        listPlace.ratingValue = Double(rating ?? 0)
        listPlace.state = state
        listPlace.userRated = NSNumber(bool: userRated!)
        listPlace.userPriced = NSNumber(bool: userPriced!)
        listPlace.userRate = NSNumber(bool: userRated!)
        listPlace.userPrice = NSNumber(bool: userPriced!)
        listPlace.userNotes = notes
        listPlace.venueId = placeId
        
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








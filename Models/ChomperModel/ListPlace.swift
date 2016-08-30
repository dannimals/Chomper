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
    
    //
    // PlaceDetailsObjectProtocol properties
    public var address: String?
    public var city: String?
    public var location = CLLocation(latitude: 0, longitude: 0)
    public var name = ""
    public var phone: String?
    public var photoUrl: String?
    public var priceValue: Double?
    public var ratingValue: Double?
    public var state: String?
    public var type = "\(ListPlace.self)"
    public var userPrice: NSNumber?
    public var userRate: NSNumber?
    public var venueId = ""
    

    // MARK: - Relationships
    
    @NSManaged public var place: Place?
    @NSManaged public var list: List?
    @NSManaged public var images: Set<Image>?
    
    // MARK: - Helpers
    
    public static func insertIntoContext(moc: NSManagedObjectContext, listName: String, placeId: String, placeName: String, downloadImageUrl: String?, rating: NSNumber?, price: NSNumber?, notes: String?, userRated: Bool? = false, userPriced: Bool? = false) -> ListPlace {
        let listPlace: ListPlace = moc.insertObject()
        
        listPlace.downloadImageUrl = downloadImageUrl
        listPlace.listImageId = downloadImageUrl
        listPlace.listName = listName
        listPlace.notes = notes
        listPlace.photoUrl = downloadImageUrl
        listPlace.placeId = placeId
        listPlace.placeName = placeName
        listPlace.price = price
        listPlace.priceValue = Double(price ?? 0)
        listPlace.rating = rating
        listPlace.ratingValue = Double(rating ?? 0)
        listPlace.userRated = NSNumber(bool: userRated!)
        listPlace.userPriced = NSNumber(bool: userPriced!)
        listPlace.userRate = NSNumber(bool: userRated!)
        listPlace.userPrice = NSNumber(bool: userPriced!)
        
        if let place = Place.findOrCreatePlace(placeId, name: placeName, inContext: moc) {
            listPlace.address = place.streetName
            listPlace.city = place.city
            listPlace.name = place.name
            listPlace.phone = place.phone
            listPlace.place = place
            listPlace.state = place.state
            listPlace.venueId = place.remoteId
            if let lat = place.latitude, long = place.longitude {
                listPlace.location = CLLocation(latitude: Double(lat), longitude: Double(long))
            }
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

//extension ListPlace: PlaceDetailsObjectProtocol {
//    
//    var city = place?.city
//    var location: CLLocation {
//        let lat = Double(place?.latitude ?? 0), long = Double(place?.longitude ?? 0)
//        return CLLocation(latitude: lat, longitude: long)
//    }
//    var name = place?.name ?? ""
//    var phone = place?.phone
//    var photoUrl = downloadImageUrl
//    var type = "\(ListPlace.self)"
//    var venueId = place?.remoteId ?? ""
//    var ratingValue: Double? {
//        if let rating = self.rating {
//            return Double(rating)
//        }
//        return nil
//    }
//    var priceValue: Double? {
//        if let price = self.price {
//            return Double(price)
//        }
//        return nil
//    }
//}







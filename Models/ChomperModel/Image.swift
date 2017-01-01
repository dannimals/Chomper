import CoreData
import CoreLocation

public final class Image: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public var createdAt: Date
    @NSManaged public fileprivate(set) var id: String
    @NSManaged public var imageData: Data
    @NSManaged public var thumbData: Data?


    // MARK: - Relationships
    
    @NSManaged public var listPlace: ListPlace?
    @NSManaged public var user: User?

    // MARK: - Helpers
    
    public static func insertIntoContext(_ moc: NSManagedObjectContext, createdAt: Date = Date(), imageData: Data, thumbData: Data?) -> Image {
        let image: Image = moc.insertObject()
        image.id = UUID().uuidString
        image.createdAt = createdAt
        image.imageData = imageData
        image.thumbData = thumbData
        return image
    }
    
    static func findOrCreateImage(_ id: String, imageData: Data, inContext moc: NSManagedObjectContext) -> Image {
        let predicate = NSPredicate(format: "id == %@", id)
        let image = findOrCreateInContext(moc, matchingPredicate: predicate) { $0.imageData = imageData; $0.id = id }
        return image
    }
}

extension Image: ManagedObjectType {
    public static var entityName: String {
        return "Image"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "createdAt", ascending: false)]
    }
}


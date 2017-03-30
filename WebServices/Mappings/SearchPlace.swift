//
//  Created by Danning Ge on 2/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import ObjectMapper

public struct SearchPlace: Mappable {
    public var address: String? = ""
    public var city: String? = ""
    public var venueId: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var name: String = ""
    public var phone: String? = ""
    public var priceValue: Double? = 0
    public var ratingValue: Double? = 0
    public var state: String? = ""
    public var zipcode: String = ""
    public var photoDict: [[String : Any]]?
    public var type = "\(SearchPlace.self)"
    public var userPrice: NSNumber? = NSNumber(value: false)
    public var userRate: NSNumber? = NSNumber(value: false as Bool)
    public var userNotes: String? = nil

    public var formattedAddress: String {
        return "\(address), \(city), \(state) \(zipcode)"
    }

    public var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    public var imageUrl: String? {
        get {
            guard let photoDict = self.photoDict?.first else { return nil }

            let size = "\(unwrapOrElse(photoDict["width"], fallback: ""))x\(unwrapOrElse(photoDict["height"], fallback: ""))"
            return "\(unwrapOrElse(photoDict["prefix"], fallback: ""))\(size)\(unwrapOrElse(photoDict["suffix"], fallback: ""))"

        }
        set {}
    }

    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        address <- map["venue.location.address"]
        city <- map["venue.location.city"]
        venueId <- map["venue.id"]
        latitude <- map["venue.location.lat"]
        longitude <- map["venue.location.lng"]
        name <- map["venue.name"]
        phone <- map["venue.contact.formattedPhone"]
        priceValue <- map["venue.price.tier"]
        ratingValue <- map["venue.rating"]
        state <- map["venue.location.state"]
        zipcode <- map["venue.location.postalCode"]
        photoDict <- map["venue.featuredPhotos.items"]
    }
}

extension SearchPlace: PlaceDetailsObjectProtocol {

}

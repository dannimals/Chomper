//
//  Created by Danning Ge on 2/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import CoreLocation
import ObjectMapper

struct SearchPlace: Mappable {
    public var address: String = ""
    public var city: String = ""
    public var id: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    public var name: String = ""
    public var phone: String = ""
    public var price: Double = 0
    public var rating: Double = 0
    public var state: String = ""
    public var zipcode: String = ""
    public var imageId: String? = nil
    
    public var formattedAddress: String {
        return "\(address), \(city), \(state) \(zipcode)"
    }
    
    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        address <- map["location.address"]
        city <- map["location.city"]
        id <- map["id"]
        latitude <- map["location.lat"]
        longitude <- map["location.lng"]
        name <- map["name"]
        phone <- map["contact.formattedPhone"]
        price <- map["price.tier"]
        rating <- map["rating"]
        state <- map["location.state"]
        zipcode <- map["location.postalCode"]
        imageId <- map["bestPhoto.id"]
    }
}

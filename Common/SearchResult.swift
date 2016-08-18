//
//  SearchResult.swift
//  Chomper
//
//  Created by Danning Ge on 7/7/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation

public struct SearchResult {
    public var address: String?
    public var city: String?
    public var location: CLLocation
    public var name: String
    public var price: Double?
    public var rating: Double?
    public var state: String?
    public var venueId: String
    public var phone: String?
    public var photoUrl: String?
    public var photoId: String?
    public var zipcode: String?
    public var formattedAddress: [String]?
    
    public init(address: String?, city: String?, formattedAddress: [String]?, location: CLLocation, name: String, phone: String? = nil, photoId: String? = nil, photoUrl: String? = nil, price: Double?, rating: Double?, state: String?, venueId: String, zipcode: String?) {
       
        self.address = address?.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.city = city?.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.formattedAddress = formattedAddress
        self.location = location
        self.name = name
        self.photoId = photoId
        self.photoUrl = photoUrl
        self.price = price
        self.rating = rating
        self.state = state?.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.venueId = venueId
        self.zipcode = zipcode?.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

}
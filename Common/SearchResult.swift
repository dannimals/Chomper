//
//  SearchResult.swift
//  Chomper
//
//  Created by Danning Ge on 7/7/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation

public struct SearchResult: PlaceDetailsObjectProtocol {
    public var address: String? {
        didSet {
            address = address?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    public var city: String? {
        didSet {
            city = city?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    public var formattedAddress: [String]?
    public var location: CLLocation
    public var name: String
    public var phone: String?
    public var imageId: String?
    public var imageUrl: String?
    public var priceValue: Double?
    public var ratingValue: Double?
    public var state: String? {
        didSet {
            state = state?.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines)
        }
    }
    public var type = "\(SearchResult.self)"
    public var userNotes: String?
    public var userPrice: NSNumber? = NSNumber(value: false as Bool)
    public var userRate: NSNumber? = NSNumber(value: false as Bool)
    public var venueId: String
    public var zipcode: String? = nil {
        didSet {
            zipcode = zipcode?.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    public init (address: String?, city: String?, formattedAddress: [String]?, location: CLLocation, name: String, phone: String?, imageId: String?, imageUrl: String?, notes: String?, price: Double?, rating: Double?, state: String?, venueId: String, zipcode: String?) {
        self.address = address
        self.city = city
        self.formattedAddress = formattedAddress
        self.location = location
        self.name = name
        self.phone = phone
        self.imageId = imageId
        self.imageUrl = imageUrl
        self.priceValue = price
        self.ratingValue = rating
        self.state = state
        self.venueId = venueId
        self.zipcode = zipcode
        self.userNotes = notes
    }
}









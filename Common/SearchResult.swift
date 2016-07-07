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
    public var location: CLLocation
    public var name: String
    public var price: Double?
    public var rating: Double?
    public var venueId: String
    
    public init(address: String?, location: CLLocation, name: String, price: Double?, rating: Double?, venueId: String) {
        self.address = address
        self.location = location
        self.name = name
        self.price = price
        self.rating = rating
        self.venueId = venueId
    }

}
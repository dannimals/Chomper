//
//  PlaceDetailsObjectProtocol.swift
//  Chomper
//
//  Created by Danning Ge on 8/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation

public protocol PlaceDetailsObjectProtocol {
    var address: String? { get set}
    var city: String? { get set }
    var location: CLLocation { get }
    var name: String { get }
    var phone: String? { get set }
    var imageUrl: String? { get set }
    var priceValue: Double? { get set }
    var ratingValue: Double? { get set }
    var state: String? { get set }
    var type: String { get }
    
    // Boolean for user set values
    var userPrice: NSNumber? { get set }
    // Boolean for user set values
    var userRate: NSNumber? { get set }
    var userNotes: String? { get set }
    var venueId: String { get }
}

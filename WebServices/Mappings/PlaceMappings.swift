//
//  PlaceMappings.swift
//  Chomper
//
//  Created by Danning Ge on 6/23/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Models
import ObjectMapper

extension Place: Mappable {
    
    // MARK: - Mappable methods
    
    convenience public init?(_ map: Map) {
        self.init()
        self.mapping(map)
    }
    
    public func mapping(map: Map) {
        city <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        streetName <- map["streetName"]
        state <- map["state"]
        zipcode <- map["zipcode"]
        price <- map["price"]
        rating <- map["rating"]
    }
}

//
//  CreatePlaceViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftyJSON

struct SearchResult {
    var address: String?
    var location: CLLocation
    var name: String
    var price: Double?
    var rating: Double?
    var venueId: String
}

struct CreatePlaceViewModel {
    
    private(set) var _results: [SearchResult]!
    
    init(jsonArray: [JSON]) {
        parseJson(jsonArray)
    }
    
    // MARK: - Helpers
    
    func numberOfRows() -> Int {
        return _results.count
    }
    
    private mutating func parseJson(results: [JSON]) {
        _results = [SearchResult]()
        for result in results {
            let venue = result["venue"]
            let name = venue["name"].string!
            let id = venue["id"].string!
            let address = venue["location"]["address"].string
            let location = CLLocation(latitude: venue["location"]["lat"].double!, longitude: venue["location"]["lng"].double!)
            let rating = venue["rating"].double
            let price = venue["price"]["tier"].double
            let place = SearchResult(address: address, location: location, name: name, price: price, rating: rating, venueId: id)
            _results.append(place)
        }
        
    }
}

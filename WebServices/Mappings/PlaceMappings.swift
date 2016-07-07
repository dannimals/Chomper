//
//  PlaceMappings.swift
//  Chomper
//
//  Created by Danning Ge on 6/23/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import SwiftyJSON

final class ChomperMapper {
    var places: [SearchResult]? = nil
    
    required init(response: NSData) {
        if let jsonString = NSString(data: response, encoding: NSUTF8StringEncoding), jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            mapResponse(JSON(data: jsonData))
        }
    }
    
    func mapResponse(json: JSON) {
        if let response = json["response"]["groups"].array, let results = response.first?["items"].array {
            parseJson(results)
        }
    }
    
    
    private func parseJson(results: [JSON]) {
        places = [SearchResult]()
        for result in results {
            let venue = result["venue"]
            let name = venue["name"].string!
            let id = venue["id"].string!
            let address = venue["location"]["address"].string
            let location = CLLocation(latitude: venue["location"]["lat"].double!, longitude: venue["location"]["lng"].double!)
            let rating = venue["rating"].double
            let price = venue["price"]["tier"].double
            let place = SearchResult(address: address, location: location, name: name, price: price, rating: rating, venueId: id)
            places?.append(place)
        }
        
    }
    
}
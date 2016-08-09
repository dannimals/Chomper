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

enum MapperType {
    case GetPlaceDetails
    case GetPlaces
    case GetRecommended
}

final class ChomperMapper {

    var places: [SearchResult]? = nil
    private var mapperType: MapperType
    
    required init(response: NSData, mapperType: MapperType) {
        self.mapperType = mapperType
        if let jsonString = NSString(data: response, encoding: NSUTF8StringEncoding), jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            mapResponse(JSON(data: jsonData), mapperType: mapperType)
        }
    }
    
    func mapResponse(json: JSON, mapperType: MapperType) {
        switch mapperType {
            case .GetPlaces:
                if let response = json["response"].dictionary, let results = response["venues"]?.array {
                    parseJson(results)
                }
            case .GetPlaceDetails:
                if let response = json["response"].dictionary, let results = response["venue"] {
                    parseJson([results])
            }
            case .GetRecommended:
                if let response = json["response"]["groups"].array, let results = response.first?["items"].array {
                    parseJson(results)
                }
            
        }
        
    }
    
    
    private func parseJson(results: [JSON]) {
        places = [SearchResult]()
        var venue: JSON!
 
        for result in results {
            switch mapperType {
            case .GetPlaces, .GetPlaceDetails:
                venue = result
            case .GetRecommended:
                venue = result["venue"]
            }
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
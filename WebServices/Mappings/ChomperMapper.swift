//
//  ChomperMapper.swift
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
        mapResponse(JSON(data: response), mapperType: mapperType)
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
            let address = venue["location"]["address"].string
            let city = venue["location"]["city"].string
            let id = venue["id"].string!
            var formattedAddress: [String]? = nil
            if let address = venue["location"]["formattedAddress"].array {
                formattedAddress = [String]()
                for element in address  {
                    formattedAddress?.append(element.stringValue)
                }
            }
            let location = CLLocation(latitude: venue["location"]["lat"].double!, longitude: venue["location"]["lng"].double!)
            let name = venue["name"].string!
            let phone = venue["contact"]["formattedPhone"].string
            let price = venue["price"]["tier"].double
            let rating = venue["rating"].double
            let state = venue["location"]["state"].string
            let zipcode = venue["location"]["postalCode"].string

            var imageUrl: String?
            var imageId: String?
            if let photoDict = venue["bestPhoto"].dictionary {
                imageId = photoDict["id"]?.string ?? ""
                let prefix = photoDict["prefix"] ?? ""
                let size = "\(photoDict["width"] ?? "")x\(photoDict["height"] ?? "")"
                let suffix = photoDict["suffix"] ?? ""
                imageUrl = "\(prefix)\(size)\(suffix)"
            }
            
            
            let place = SearchResult(address: address, city: city, formattedAddress: formattedAddress, location: location, name: name, phone: phone, imageId: imageId, imageUrl: imageUrl, price: price, rating: rating, state: state, venueId: id, zipcode: zipcode)
            places?.append(place)
        }
        
    }
    
}
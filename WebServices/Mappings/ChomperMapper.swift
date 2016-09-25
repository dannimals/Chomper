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
    case GetPhotos
    case GetPlaceDetails
    case GetPlaces
    case GetRecommended
}

final class ChomperMapper {

    var photos: [Photo]? = nil
    var places: [SearchResult]? = nil
    private var mapperType: MapperType
    
    required init(response: NSData, mapperType: MapperType) {
        self.mapperType = mapperType
        mapResponse(JSON(data: response), mapperType: mapperType)
    }
    
    func mapResponse(json: JSON, mapperType: MapperType) {
        switch mapperType {
            case .GetPhotos:
                guard let response = json["response"].dictionary, count = response["photos"]?["count"].intValue where count > 0 else { photos = nil; return }
                if let results = response["photos"]?["items"].array {
                    parseJsonPhotos(results)
                }
            case .GetPlaces:
                if let response = json["response"].dictionary, results = response["venues"]?.array {
                    parseJsonPlaces(results)
                }
            case .GetPlaceDetails:
                if let response = json["response"].dictionary, results = response["venue"] {
                    parseJsonPlaces([results])
            }
            case .GetRecommended:
                if let response = json["response"]["groups"].array, results = response.first?["items"].array {
                    parseJsonPlaces(results)
                }
            
        }
        
    }
    
    
    // MARK: - Helpers
    
    private func parseJsonPhotos(results: [JSON]) {
        photos = [Photo]()
        
        for result in results {
            let id = result["id"].string ?? "",
            height = result["height"].int ?? 0,
            width = result["width"].int ?? 0,
            prefix = result["prefix"].string ?? "",
            suffix = result["suffix"].string ?? "",
            url = "\(prefix)\(width)x\(height)\(suffix)"
            photos?.append(Photo(id: id, width: width, height: height, url: url))
        }
    }
    
    private func parseJsonPlaces(results: [JSON]) {
        places = [SearchResult]()
        var venue: JSON!
 
        for result in results {
            switch mapperType {
            case .GetPlaces, .GetPlaceDetails:
                venue = result
            case .GetRecommended:
                venue = result["venue"]
            case .GetPhotos:
                break
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
            
            
            let place = SearchResult(address: address, city: city, formattedAddress: formattedAddress, location: location, name: name, phone: phone, imageId: imageId, imageUrl: imageUrl, notes: nil, price: price, rating: rating, state: state, venueId: id, zipcode: zipcode)
            places?.append(place)
        }
    }
    
}
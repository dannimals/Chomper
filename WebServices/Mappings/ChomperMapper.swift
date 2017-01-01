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
    case getPhotos
    case getPlaceDetails
    case getPlaces
    case getRecommended
}

final class ChomperMapper {

    var photos: [Photo]? = nil
    var places: [SearchResult]? = nil
    fileprivate var mapperType: MapperType
    
    required init(response: Data, mapperType: MapperType) {
        self.mapperType = mapperType
        mapResponse(JSON(data: response), mapperType: mapperType)
    }
    
    func mapResponse(_ json: JSON, mapperType: MapperType) {
        switch mapperType {
            case .getPhotos:
                guard let response = json["response"].dictionary, let count = response["photos"]?["count"].intValue, count > 0 else { photos = nil; return }
                if let results = response["photos"]?["items"].array {
                    parseJsonPhotos(results)
                }
            case .getPlaces:
                if let response = json["response"].dictionary, let results = response["venues"]?.array {
                    parseJsonPlaces(results)
                }
            case .getPlaceDetails:
                if let response = json["response"].dictionary, let results = response["venue"] {
                    parseJsonPlaces([results])
            }
            case .getRecommended:
                if let response = json["response"]["groups"].array, let results = response.first?["items"].array {
                    parseJsonPlaces(results)
                }
            
        }
        
    }
    
    
    // MARK: - Helpers
    
    fileprivate func parseJsonPhotos(_ results: [JSON]) {
        photos = [Photo]()
        
        for result in results where result["visibility"].string == "public" {
            let id = result["id"].string ?? "",
            height = result["height"].int ?? 0,
            width = result["width"].int ?? 0,
            prefix = result["prefix"].string ?? "",
            suffix = result["suffix"].string ?? "",
            url = "\(prefix)\(width)x\(height)\(suffix)"
            photos?.append(Photo(id: id, width: width, height: height, url: url))
        }
    }
    
    fileprivate func parseJsonPlaces(_ results: [JSON]) {
        places = [SearchResult]()
        var venue: JSON!
 
        for result in results {
            switch mapperType {
            case .getPlaces, .getPlaceDetails:
                venue = result
            case .getRecommended:
                venue = result["venue"]
            case .getPhotos:
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
            } else {
                if let venuePhotos = venue["photos"]["groups"].array, let item = venuePhotos.first?["items"].array?.first {
                    if let prefix = item["prefix"].string, let width = item["width"].int, let height = item["height"].int, let suffix = item["suffix"].string {
                        let size = "\(width)x\(height)"
                        imageUrl = "\(prefix)\(size)\(suffix)"
                    }
                
                }
            }

          
            
            let place = SearchResult(address: address, city: city, formattedAddress: formattedAddress, location: location, name: name, phone: phone, imageId: imageId, imageUrl: imageUrl, notes: nil, price: price, rating: rating, state: state, venueId: id, zipcode: zipcode)
            places?.append(place)
        }
    }
    
}

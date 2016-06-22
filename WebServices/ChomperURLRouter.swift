//
//  ChomperURLRouter.swift
//  Chomper
//
//  Created by Danning Ge on 6/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation
import Foundation

public struct ChomperURLRouter {
    
    //
    // MARK: - Properties
    
    private static let dateFormatter = NSDateFormatter()
    private static let dateFormat = "YYYYMMDD"
    private static let baseURLString = "https://api.foursquare.com/v2"
    private static let clientId = "MDNOUO12E1RRL20OOJZJHWGM5ZBLLKUHERL31DEHODYHYUK5"
    private static let clientSecret = "DIG45IF1K2FWUBGQLAZGYYJGLUCOZMTQRCPE0WQY5TMNH32B"
    private static let baseParameters = [
        "client_id": ChomperURLRouter.clientId,
        "client_secret": ChomperURLRouter.clientSecret,
    ]
    
    //
    // Enumeration that provides type-safe URL routing to Foursquare's API endpoints.

    enum Path: String {
        case getPlacesNearLocation = "/venues/search"
    }
    
    static func getPlacesNearLocation(location: CLLocation, searchTerm: String?) -> NSURLRequest {
        var parameters = [String: String]()
        parameters["ll"] = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        if let searchTerm = searchTerm {
            parameters["query"] = searchTerm
        }
        
        return chomperURL(method: .getPlacesNearLocation, parameters: parameters)
    }

    static func getPlacesNearArea(area: String, searchTerm: String?) -> NSURLRequest {
        var parameters = [String:String]()
        parameters["near"] = area

        if let searchTerm = searchTerm {
            parameters["query"] = searchTerm
        }
        
        return chomperURL(method: .getPlacesNearLocation, parameters: parameters)
    }
    
    private static func chomperURL(method method: ChomperURLRouter.Path, parameters: [String: String]?) -> NSURLRequest {
        var baseParams = baseParameters
        dateFormatter.dateFormat = dateFormat
        baseParams["v"] = dateFormatter.stringFromDate(NSDate())

        let url = ChomperURLRouter.baseURLString.stringByAppendingString(method.rawValue)
        let components = NSURLComponents(string: url)
        var queryItems = [NSURLQueryItem]()
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components?.queryItems = queryItems
        return NSURLRequest(URL: components?.URL ?? NSURL())
    }
}



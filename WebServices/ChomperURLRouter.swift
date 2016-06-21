//
//  ChomperURLRouter.swift
//  Chomper
//
//  Created by Danning Ge on 6/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

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
        //TODO: hard-code location for now, need to figure out how to pass in coordinates
        "client_id": ChomperURLRouter.clientId,
        "client_secret": ChomperURLRouter.clientSecret,
        "near": "New York, NY"
    ]
    
    //
    // Enumeration that provides type-safe URL routing to Foursquare API endpoints.

    enum Method: String {
        case getVenuesForSearch = "/venues/search"
    }
    
    
    //TODO: pass in user's location as parameter, hardcode for NYC for now
    //TODO: default to current location, create another method that takes "near" as a param
    static func getVenuesForSearch(searchTerm: String?) -> NSURLRequest {
        var parameters: [String : String]?
        if let searchTerm = searchTerm {
            parameters = [String: String]()
            parameters!["query"] = searchTerm
        }
        
        // if let location = location {}
        return chomperURL(method: .getVenuesForSearch, parameters: parameters)
    }
    
    private static func chomperURL(method method: ChomperURLRouter.Method, parameters: [String: String]?) -> NSURLRequest {
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



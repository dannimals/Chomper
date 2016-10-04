//
//  ChomperURLRouter.swift
//  Chomper
//
//  Created by Danning Ge on 6/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation

public protocol URLRequestConvertible {
    var URLRequest: NSURLRequest { get }
}

//
// Enumeration that provides type-safe URL routing to Foursquare's API endpoints.

public enum ChomperURLRouter: URLRequestConvertible {
    
    //
    // MARK: - Properties
    
    private static let dateFormatter = NSDateFormatter()
    private static let dateFormat = "YYYYMMDD"
    private static let baseURLString = "https://api.foursquare.com/v2"
    private static let clientId = "MDNOUO12E1RRL20OOJZJHWGM5ZBLLKUHERL31DEHODYHYUK5"
    private static let clientSecret = "DIG45IF1K2FWUBGQLAZGYYJGLUCOZMTQRCPE0WQY5TMNH32B"

    public enum Method: String {
        case GET, POST, PUT, DELETE
    }
    
    case ExplorePlacesNearArea(String, String?)
    case ExplorePlacesNearLocation(CLLocation, String?)
    case GetDetailsForPlace(String)
    case GetPhotosForPlace(String)
    case GetPlacesNearArea(String, String?)
    case GetPlacesNearLocation(CLLocation, String?)
    
    private var method: Method {
        switch self {
            default: return .GET
        }
    }
    
    private var path: String {
        switch self {
        case .ExplorePlacesNearArea:
            return "/venues/explore/"
        case .ExplorePlacesNearLocation:
            return "/venues/explore/"
        case let .GetDetailsForPlace(id):
            return "/venues/\(id)"
        case let .GetPhotosForPlace(id):
            return "/venues/\(id)/photos"
        case .GetPlacesNearArea:
            return "/venues/search/"
        case .GetPlacesNearLocation:
            return "/venues/search/"
        }
    }
    
    // MARK: URLRequestConvertible methods
    
    public var URLRequest: NSURLRequest {
        ChomperURLRouter.dateFormatter.dateFormat = ChomperURLRouter.dateFormat
        let URL = NSURL(string: ChomperURLRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        let components = NSURLComponents(string: ChomperURLRouter.baseURLString)
        var parameters = [NSURLQueryItem]()
        parameters.append(NSURLQueryItem(name: "v", value: ChomperURLRouter.dateFormatter.stringFromDate(NSDate())))
        parameters.append(NSURLQueryItem(name: "client_id", value: ChomperURLRouter.clientId))
        parameters.append(NSURLQueryItem(name: "client_secret", value: ChomperURLRouter.clientSecret))

        switch self {
        case let .ExplorePlacesNearArea(area, searchTerm):
            parameters.append(NSURLQueryItem(name: "near", value: area))
            
            if let searchTerm = searchTerm {
                parameters.append(NSURLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.URL else { fatalError("Invalid GetPlacesNearArea URL") }
            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            
            return mutableRequest
            
        case let .ExplorePlacesNearLocation(location, searchTerm):
            parameters.append(NSURLQueryItem(name: "ll", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"))
            parameters.append(NSURLQueryItem(name: "venuePhotos", value: "\(1)"))
            
            if let searchTerm = searchTerm {
                parameters.append(NSURLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.URL else { fatalError("Invalid GetPlacesNearLocation URL") }
            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            
            return mutableRequest
            
        case .GetDetailsForPlace:
            components?.queryItems = parameters
            guard let url = components?.URL else { fatalError("Invalid GetDetailsForPlace URL") }
            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            
            return mutableRequest
        
        case .GetPhotosForPlace:
            components?.queryItems = parameters
            guard let url = components?.URL else { fatalError("Invalid GetDetailsForPlace URL") }
            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            
            return mutableRequest
            
        case let .GetPlacesNearArea(area, searchTerm):
            parameters.append(NSURLQueryItem(name: "near", value: area))
            
            if let searchTerm = searchTerm {
                parameters.append(NSURLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.URL else { fatalError("Invalid GetPlacesNearArea URL") }
            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            
            return mutableRequest
        
        case let .GetPlacesNearLocation(location, searchTerm):
          
            parameters.append(NSURLQueryItem(name: "ll", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"))
            
            if let searchTerm = searchTerm {
                parameters.append(NSURLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.URL else { fatalError("Invalid GetPlacesNearLocation URL") }
            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            
            return mutableRequest
        }
    }
}



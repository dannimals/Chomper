//
//  ChomperURLRouter.swift
//  Chomper
//
//  Created by Danning Ge on 6/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation

public protocol URLRequestConvertible {
    var URLRequest: Foundation.URLRequest { get }
}

//
// Enumeration that provides type-safe URL routing to Foursquare's API endpoints.

public enum ChomperURLRouter: URLRequestConvertible {
    
    //
    // MARK: - Properties
    
    fileprivate static let dateFormatter = DateFormatter()
    fileprivate static let dateFormat = "YYYYMMDD"
    fileprivate static let baseURLString = "https://api.foursquare.com/v2"
    fileprivate static let clientId = "MDNOUO12E1RRL20OOJZJHWGM5ZBLLKUHERL31DEHODYHYUK5"
    fileprivate static let clientSecret = "DIG45IF1K2FWUBGQLAZGYYJGLUCOZMTQRCPE0WQY5TMNH32B"

    public enum Method: String {
        case GET, POST, PUT, DELETE
    }
    
    case explorePlacesNearArea(String, String?)
    case explorePlacesNearLocation(CLLocation, String?)
    case getDetailsForPlace(String)
    case getPhotosForPlace(String)
    case getPlacesNearArea(String, String?)
    case getPlacesNearLocation(CLLocation, String?)
    
    fileprivate var method: Method {
        switch self {
            default: return .GET
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .explorePlacesNearArea:
            return "/venues/explore/"
        case .explorePlacesNearLocation:
            return "/venues/explore/"
        case let .getDetailsForPlace(id):
            return "/venues/\(id)"
        case let .getPhotosForPlace(id):
            return "/venues/\(id)/photos"
        case .getPlacesNearArea:
            return "/venues/search/"
        case .getPlacesNearLocation:
            return "/venues/search/"
        }
    }
    
    // MARK: URLRequestConvertible methods
    
    public var URLRequest: Foundation.URLRequest {
        ChomperURLRouter.dateFormatter.dateFormat = ChomperURLRouter.dateFormat
        let URL = Foundation.URL(string: ChomperURLRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(url: URL.appendingPathComponent(path))
        mutableURLRequest.httpMethod = method.rawValue
        
        var components = URLComponents(string: ChomperURLRouter.baseURLString)
        var parameters = [URLQueryItem]()
        parameters.append(URLQueryItem(name: "v", value: ChomperURLRouter.dateFormatter.string(from: Date())))
        parameters.append(URLQueryItem(name: "client_id", value: ChomperURLRouter.clientId))
        parameters.append(URLQueryItem(name: "client_secret", value: ChomperURLRouter.clientSecret))

        switch self {
        case let .explorePlacesNearArea(area, searchTerm):
            parameters.append(URLQueryItem(name: "near", value: area))
            
            if let searchTerm = searchTerm {
                parameters.append(URLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.url else { fatalError("Invalid GetPlacesNearArea URL") }
            let mutableRequest = NSMutableURLRequest(url: url.appendingPathComponent(path))
            
            return mutableRequest as URLRequest
            
        case let .explorePlacesNearLocation(location, searchTerm):
            parameters.append(URLQueryItem(name: "ll", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"))
            parameters.append(URLQueryItem(name: "venuePhotos", value: "\(1)"))
            
            if let searchTerm = searchTerm {
                parameters.append(URLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.url else { fatalError("Invalid GetPlacesNearLocation URL") }
            let mutableRequest = NSMutableURLRequest(url: url.appendingPathComponent(path))
            
            return mutableRequest as URLRequest
            
        case .getDetailsForPlace:
            components?.queryItems = parameters
            guard let url = components?.url else { fatalError("Invalid GetDetailsForPlace URL") }
            let mutableRequest = NSMutableURLRequest(url: url.appendingPathComponent(path))
            
            return mutableRequest as URLRequest
        
        case .getPhotosForPlace:
            components?.queryItems = parameters
            guard let url = components?.url else { fatalError("Invalid GetDetailsForPlace URL") }
            let mutableRequest = NSMutableURLRequest(url: url.appendingPathComponent(path))
            
            return mutableRequest as URLRequest
            
        case let .getPlacesNearArea(area, searchTerm):
            parameters.append(URLQueryItem(name: "near", value: area))
            
            if let searchTerm = searchTerm {
                parameters.append(URLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.url else { fatalError("Invalid GetPlacesNearArea URL") }
            let mutableRequest = NSMutableURLRequest(url: url.appendingPathComponent(path))
            
            return mutableRequest as URLRequest
        
        case let .getPlacesNearLocation(location, searchTerm):
          
            parameters.append(URLQueryItem(name: "ll", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"))
            
            if let searchTerm = searchTerm {
                parameters.append(URLQueryItem(name: "query", value: searchTerm))
            }
            components?.queryItems = parameters
            guard let url = components?.url else { fatalError("Invalid GetPlacesNearLocation URL") }
            let mutableRequest = NSMutableURLRequest(url: url.appendingPathComponent(path))
            
            return mutableRequest as URLRequest
        }
    }
}



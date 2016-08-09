//
//  ChomperWebServiceS.swift
//  Chomper
//
//  Created by Danning Ge on 6/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import SwiftyJSON

public typealias GetPlacesCompletionHandler = ([SearchResult]?, NSURLResponse?, NSError?) -> Void
public typealias GetPlaceCompletionHandler = (SearchResult?, NSURLResponse?, NSError?) -> Void

public protocol ChomperWebServiceProtocol {
    func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
    func getRecommendedPlacesNearArea(area: String, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
    func getDetailsForPlace(id: String, completionHandler: GetPlaceCompletionHandler) -> NSURLSessionDataTask
    func getPlacesNearArea(area: String, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
    func getPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
}

public class ChomperWebService: ChomperWebServiceProtocol {

    // MARK: - Class properties
    
    static var session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let _session = NSURLSession(configuration: config)
        
        return _session
    }()


    // MARK: - Class methods
    
    public static func createWebService() -> ChomperWebService {
        return ChomperWebService()
    }
    
    
    // MARK: - Place Details
    
    public func getDetailsForPlace(id: String, completionHandler: GetPlaceCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.GetDetailsForPlace(id).URLRequest
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .GetPlaceDetails).places
                completionHandler(results?.first, response, nil)

            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
    
    // MARK: - Places from explore (user recommendation)
    
    public func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.ExplorePlacesNearLocation(location, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .GetRecommended).places
                completionHandler(results, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
    
    public func getRecommendedPlacesNearArea(area: String, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.ExplorePlacesNearArea(area, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .GetRecommended).places
                completionHandler(results, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
    
    
    // MARK: - Places from search

    public func getPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.GetPlacesNearLocation(location, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .GetPlaces).places
                completionHandler(results, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
    
    public func getPlacesNearArea(area: String, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.GetPlacesNearArea(area, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .GetPlaces).places
                completionHandler(results, response, nil)

            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
}



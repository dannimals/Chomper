//
//  ChomperWebServiceS.swift
//  Chomper
//
//  Created by Danning Ge on 6/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation
import Foundation

public typealias GetPlacesCompletionHandler = (NSData?, NSURLResponse?, NSError?) -> Void

public protocol ChomperWebServiceProtocol {
    func getDetailsForPlace(id: String, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
    func getPlacesNearArea(area: String, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
    func getPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
}

public class ChomperWebService: ChomperWebServiceProtocol {
    
    // MARK: - Class properties
    
    static var session: NSURLSession {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let _session = NSURLSession(configuration: config)
        
        return _session
    }


    // MARK: - Class methods
    
    public static func createWebService() -> ChomperWebService {
        return ChomperWebService()
    }
    
    // MARK: - Place Details
    
    public func getDetailsForPlace(id: String, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.GetDetailsForPlace(id).URLRequest
        print(request)
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                completionHandler(data, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
    
    
    // MARK: - Places
    //TODO: make sure these default to background thread

    public func getPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.GetPlacesNearLocation(location, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                completionHandler(data, response, nil)
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
            if error == nil {
                completionHandler(data, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
        return task
    }

}

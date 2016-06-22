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
    func getPlacesNearArea(area: String, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
    func getPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask
}

public class ChomperWebService: ChomperWebServiceProtocol {
    
    // MARK: - Class methods
    
    public static func createWebService() -> ChomperWebService {
        return ChomperWebService()
    }
    
    // MARK: - Places
    //TODO: make sure these default to background thread

    public func getPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: GetPlacesCompletionHandler) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.getPlacesNearLocation(location, searchTerm: searchTerm)
        let session = NSURLSession(configuration: .defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
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
        let request = ChomperURLRouter.getPlacesNearArea(area, searchTerm: searchTerm)
        let session = NSURLSession(configuration: .defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
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

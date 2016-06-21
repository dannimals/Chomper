//
//  ChomperWebServiceS.swift
//  Chomper
//
//  Created by Danning Ge on 6/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Foundation

public typealias GetVenuesCompletion = (NSData?, NSURLResponse?, NSError?) -> Void

public protocol ChomperWebServiceProtocol {
    // MARK: - Venues
    func getVenuesForSearch(searchTerm: String?, completionHandler: GetVenuesCompletion) -> NSURLSessionDataTask
}

public class ChomperWebService: ChomperWebServiceProtocol {
    // MARK: - Class methods
    
    public static func createWebService() -> ChomperWebService {
        return ChomperWebService()
    }
    
    // MARK: - Venues
    
    //TODO: make sure this defaults to background
    public func getVenuesForSearch(searchTerm: String?, completionHandler: GetVenuesCompletion) -> NSURLSessionDataTask {
        let request = ChomperURLRouter.getVenuesForSearch(searchTerm)
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

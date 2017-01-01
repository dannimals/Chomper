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

public typealias GetPhotosCompletionHandler = ([Photo]?, URLResponse?, Error?) -> Void
public typealias GetPlacesCompletionHandler = ([SearchResult]?, URLResponse?, Error?) -> Void
public typealias GetPlaceCompletionHandler = (SearchResult?, URLResponse?, Error?) -> Void

public protocol ChomperWebServiceProtocol {
    func getRecommendedPlacesNearLocation(_ location: CLLocation, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask
    func getRecommendedPlacesNearArea(_ area: String, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask
    func getDetailsForPlace(_ id: String, completionHandler: @escaping GetPlaceCompletionHandler) -> URLSessionDataTask
    func getPhotosForPlace(_ id: String, completionHandler: @escaping GetPhotosCompletionHandler) -> URLSessionDataTask
    func getPlacesNearArea(_ area: String, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask
    func getPlacesNearLocation(_ location: CLLocation, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask
}

public class ChomperWebService: ChomperWebServiceProtocol {

    // MARK: - Class properties
    
    static var session: URLSession = {
        let config = URLSessionConfiguration.default
        let _session = URLSession(configuration: config)
        
        return _session
    }()


    // MARK: - Class methods
    
    public static func createWebService() -> ChomperWebService {
        return ChomperWebService()
    }
    
    
    // MARK: - Place Details
    
    public func getDetailsForPlace(_ id: String, completionHandler: @escaping GetPlaceCompletionHandler) -> URLSessionDataTask {
        let request = ChomperURLRouter.getDetailsForPlace(id).URLRequest
        let task = ChomperWebService.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .getPlaceDetails).places
                completionHandler(results?.first, response, nil)

            } else {
                completionHandler(nil, nil, error)
            }
        }) 
        task.resume()
        return task
    }
    
    public func getPhotosForPlace(_ id: String, completionHandler: @escaping GetPhotosCompletionHandler) -> URLSessionDataTask {
        let request = ChomperURLRouter.getPhotosForPlace(id).URLRequest
        let task = ChomperWebService.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                let photos = ChomperMapper(response: data, mapperType: .getPhotos).photos
                completionHandler(photos, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }) 
        task.resume()
        return task
    }
    
    // MARK: - Places from explore (user recommendation)

    public func getRecommendedPlacesNearLocation(_ location: CLLocation, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask {
        let request = ChomperURLRouter.explorePlacesNearLocation(location, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .getRecommended).places
                completionHandler(results, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }) 
        task.resume()
        return task
    }
    
    public func getRecommendedPlacesNearArea(_ area: String, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask {
        let request = ChomperURLRouter.explorePlacesNearArea(area, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .getRecommended).places
                completionHandler(results, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }) 
        task.resume()
        return task
    }
    
    
    // MARK: - Places from search

    public func getPlacesNearLocation(_ location: CLLocation, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask {
        let request = ChomperURLRouter.getPlacesNearLocation(location, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .getPlaces).places
                completionHandler(results, response, nil)
            } else {
                completionHandler(nil, nil, error)
            }
        }) 
        task.resume()
        return task
    }
    
    public func getPlacesNearArea(_ area: String, searchTerm: String?, completionHandler: @escaping GetPlacesCompletionHandler) -> URLSessionDataTask {
        let request = ChomperURLRouter.getPlacesNearArea(area, searchTerm).URLRequest
        let task = ChomperWebService.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                let results = ChomperMapper(response: data, mapperType: .getPlaces).places
                completionHandler(results, response, nil)

            } else {
                completionHandler(nil, nil, error)
            }
        }) 
        task.resume()
        return task
    }
}



//
//  FoursquareWebServicesTests.swift
//  WebServicesTests
//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Common
@testable import SwiftyJSON
@testable import WebServices

class FoursquareWebServicesTests: XCTestCase {
    let searchTerm = "cafes"
    let searchArea = "manhattan"
    let searchLocation = CLLocation(latitude: 40.7, longitude: -74.0)
    let placeId = "517abbd7e4b0de63518cb59e"

    var chomperWebService: ChomperWebServiceProtocol!
    var data: Data?
    
    override func setUp() {
        super.setUp()
        chomperWebService = ChomperWebService.createWebService()
    }
    
    override func tearDown() {
        chomperWebService = nil
        data = nil
        super.tearDown()
    }
    
    func testAsyncExplorePlacesNearArea() {
        let request = ChomperURLRouter.explorePlacesNearArea(searchArea, searchTerm).URLRequest
        let expectation = self.expectation(withDescription: "GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! HTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.url, request.url)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }) 
        
        task.resume()
        
        waitForExpectations(withTimeout: (task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .getRecommended, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }
    
    func testAsyncExplorePlacesNearLocation() {
        let request = ChomperURLRouter.explorePlacesNearLocation(searchLocation, searchTerm).URLRequest
        let expectation = self.expectation(withDescription: "GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! HTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.url, request.url)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }) 
        
        task.resume()
        
        waitForExpectations(withTimeout: (task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .getRecommended, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }

    func testAsyncGetDetailsForPlace() {
        let request = ChomperURLRouter.getDetailsForPlace(placeId).URLRequest
        let expectation = self.expectation(withDescription: "GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! HTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.url, request.url)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }) 
        
        task.resume()
        
        waitForExpectations(withTimeout: (task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .getPlaceDetails, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }

    func testAsyncGetPlacesForArea() {
        let request = ChomperURLRouter.getPlacesNearArea(searchArea, searchTerm).URLRequest
        let expectation = self.expectation(withDescription: "GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! HTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.url, request.url)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }) 
        
        task.resume()
        
        waitForExpectations(withTimeout: (task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .getPlaces, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }
    
    func testAsyncGetPlacesForLocation() {
        let request = ChomperURLRouter.getPlacesNearLocation(searchLocation, searchTerm).URLRequest
        let expectation = self.expectation(withDescription: "GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! HTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.url, request.url)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }) 
        
        task.resume()
        
        waitForExpectations(withTimeout: (task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .getPlaces, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }

}

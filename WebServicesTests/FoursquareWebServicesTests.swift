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
    var data: NSData?
    
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
        let request = ChomperURLRouter.ExplorePlacesNearArea(searchArea, searchTerm).URLRequest
        let expectation = expectationWithDescription("GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! NSHTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.URL, request.URL)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout((task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .GetRecommended, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }
    
    func testAsyncExplorePlacesNearLocation() {
        let request = ChomperURLRouter.ExplorePlacesNearLocation(searchLocation, searchTerm).URLRequest
        let expectation = expectationWithDescription("GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! NSHTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.URL, request.URL)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout((task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .GetRecommended, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }

    func testAsyncGetDetailsForPlace() {
        let request = ChomperURLRouter.GetDetailsForPlace(placeId).URLRequest
        let expectation = expectationWithDescription("GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! NSHTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.URL, request.URL)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout((task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .GetPlaceDetails, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }

    func testAsyncGetPlacesForArea() {
        let request = ChomperURLRouter.GetPlacesNearArea(searchArea, searchTerm).URLRequest
        let expectation = expectationWithDescription("GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! NSHTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.URL, request.URL)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout((task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .GetPlaces, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }
    
    func testAsyncGetPlacesForLocation() {
        let request = ChomperURLRouter.GetPlacesNearLocation(searchLocation, searchTerm).URLRequest
        let expectation = expectationWithDescription("GET \(request)")
        let session = ChomperWebService.session
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNotNil(data)
            self.data = data
            XCTAssertNil(error)
            
            let httpResponse = response as! NSHTTPURLResponse
            if let response = response {
                XCTAssertEqual(response.URL, request.URL)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response was not NSURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout((task.originalRequest?.timeoutInterval)!) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.cancel()
            } else {
                let test = WebServicesTestHelper(mapperType: .GetPlaces, data: self.data!)
                XCTAssertNotNil(test)
            }
        }
    }

}

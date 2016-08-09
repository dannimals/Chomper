//
//  GetDetailsForPlaceTest.swift
//  Chomper
//
//  Created by Danning Ge on 8/9/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Common
@testable import SwiftyJSON
@testable import WebServices

class GetDetailsForPlaceTest: XCTestCase {
    let placeId = "4c5435bf4623be9a62ee66f2"
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
    
    func testAsyncExplorePlacesAndChomperMapper() {
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
                // Given
                let jsonString = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
                let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                let json = JSON(data: jsonData)
                let mapper = ChomperMapper(response: self.data!, mapperType: .GetPlaceDetails)
                
                // When
                let response = json["response"].dictionary!
                let venue = response["venue"]!
                
                // Then
                XCTAssertEqual(mapper.places?.count, 1)
                XCTAssertNotNil(venue)
                XCTAssertNotNil(venue["name"].string)
                XCTAssertNotNil(venue["id"].string)
                XCTAssertNotNil(venue["location"]["lat"].double)
                XCTAssertNotNil(venue["location"]["lng"].double)
                if venue["rating"] != nil {
                    XCTAssertNotNil(venue["rating"].double)
                }
                if venue["price"]["tier"] != nil {
                    XCTAssertNotNil(venue["price"]["tier"].double)
                }
            }
        }
    }
    
}

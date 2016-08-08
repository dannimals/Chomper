//
//  WebServicesTests.swift
//  WebServicesTests
//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
@testable import Common
@testable import SwiftyJSON
@testable import WebServices

class ExplorePlacesNearAreaTest: XCTestCase {
    let searchTerm = "cafes"
    let searchArea = "manhattan"
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
            } else {
                // Given
                let jsonString = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
                let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                let json = JSON(data: jsonData)
                
                // When
                let response = json["response"]["groups"].array!
                let results = response.first?["items"].array!
                let testResult = results!.first!
                let venue = testResult["venue"]
                
                // Then
                XCTAssertNotNil(results)
                XCTAssertNotNil(venue)
                XCTAssertNotNil(venue["name"].string!)
                XCTAssertNotNil(venue["id"].string!)
                XCTAssertNotNil(venue["location"]["lat"].double!)
                XCTAssertNotNil(venue["location"]["lng"].double!)
//                XCTAssertNotNil(venue["rating"].double)
//                XCTAssertNotNil(venue["price"]["tier"].double)

            }
            task.cancel()
        }
    }

}

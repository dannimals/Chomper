//
//  WebServicesTestHelper.swift
//  Chomper
//
//  Created by Danning Ge on 8/9/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import WebServices

//
// MARK: - Helper class for testing ChomperMapper 
// for each Foursquare API endpoint integration

enum MapperType {
    case GetPlaceDetails
    case GetPlaces
    case GetRecommended
}

class WebServicesTestHelper {
    var mapperType: MapperType
    var data: NSData!
    
    required init(mapperType: MapperType, data: NSData) {
        self.mapperType = mapperType
        self.data = data
        testMapper(mapperType)
    }
    
    func testMapper(mapperType: MapperType) {
        let jsonString = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
        let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let json = JSON(data: jsonData)
        let venue: JSON

        switch mapperType {
            case .GetPlaces:
                // Given
                let mapper = ChomperMapper(response: self.data!, mapperType: .GetPlaces)
                
                // When
                let response = json["response"].dictionary!
                let results = response["venues"]!.array!
                venue = results.first!
                
                // Then
                XCTAssertEqual(mapper.places?.count, results.count)
                XCTAssertNotNil(results)
            
            case .GetPlaceDetails:
                // Given
                let mapper = ChomperMapper(response: self.data!, mapperType: .GetPlaceDetails)
                
                // When
                let response = json["response"].dictionary!
                venue = response["venue"]!
                
                // Then
                XCTAssertEqual(mapper.places?.count, 1)
            
            case .GetRecommended:
                // Given
                let mapper = ChomperMapper(response: self.data!, mapperType: .GetRecommended)
                
                // When
                let response = json["response"]["groups"].array!
                let results = response.first?["items"].array!
                let testResult = results!.first!
                venue = testResult["venue"]
                
                // Then
                XCTAssertEqual(mapper.places?.count, results?.count)
                XCTAssertNotNil(results)
        }
    
        // Then 
        XCTAssertNotNil(venue)
        XCTAssertNotNil(venue["name"].string)
        XCTAssertNotNil(venue["id"].string)
        XCTAssertNotNil(venue["location"]["lat"].double)
        XCTAssertNotNil(venue["location"]["lng"].double)
        if venue["contact"]["formattedPhone"] != nil {
            XCTAssertNotNil(venue["contact"]["formattedPhone"].string)
        }
        if venue["rating"] != nil {
            XCTAssertNotNil(venue["rating"].double)
        }
        if venue["price"]["tier"] != nil {
            XCTAssertNotNil(venue["price"]["tier"].double)
        }
        
    }
    
}

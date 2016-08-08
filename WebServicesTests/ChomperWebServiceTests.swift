//
//  ChomperWebServiceTests.swift
//  Chomper
//
//  Created by Danning Ge on 8/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
@testable import WebServices

class ChomperWebServiceTests: XCTestCase {
    var chomperWebService: ChomperWebServiceProtocol!
        
    override func setUp() {
        super.setUp()
        
        chomperWebService = ChomperWebService.createWebService()
     }
    
    override func tearDown() {
        chomperWebService = nil
        
        super.tearDown()
    }
    
    func testWebServiceExists() {
        XCTAssertNotNil(chomperWebService)
    
    }

}

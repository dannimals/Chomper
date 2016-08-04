//
//  ModelsTests.swift
//  ModelsTests
//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
@testable import Models

class ListTests: XCTestCase {
    var moc: NSManagedObjectContext!
    var list: List?
    var place: Place?
    let email = "test@email.com"
    let listName = "list"
    let placeName = "place"
    
    override func setUp() {
        super.setUp()
        moc = setupTestingManagedContext()
        
        moc.performChangesAndWait {
            List.insertIntoContext(self.moc, name: self.listName, ownerEmail: self.email)
        }
        
        moc.performChangesAndWait {
            Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName])
        }
        
        let fetch = NSFetchRequest(entityName: List.entityName)
        list = try! moc.executeFetchRequest(fetch).first as? List

        
        let f = NSFetchRequest(entityName: Place.entityName)
        place = try! moc.executeFetchRequest(f).first as? Place
    }
    
    func testMoc() {
        XCTAssertNotNil(moc)
    }
    
    func testAddList() {
        XCTAssertNotNil(list)
    }

    func testAddPlace() {
        XCTAssertNotNil(place)
    }
    
    func testAddPlaceToList() {
        XCTAssertEqual(list!.name, listName)
        XCTAssertEqual(place!.name, placeName)

        //
        // Test relationship exists between list and place
        let placeList = place!.lists!.first!
        XCTAssertEqual(place!.lists?.count, 1)
        XCTAssertEqual(placeList.name, list!.name)
        XCTAssertEqual(placeList.owner?.email, email)
        
    }
    
    override func tearDown() {
        moc = nil
        list = nil
        place = nil
        super.tearDown()
    }
    
}

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
    let email = "test@email.com"
    let listName = "list"
    let placeName = "place"
    
    override func setUp() {
        super.setUp()
        moc = setupTestingManagedContext()
    }
    
    func testMoc() {
        XCTAssertNotNil(moc)
    }
    
    func testAddList() {
        // Given
        var list = NSObject()
        
        // When
        moc.performChangesAndWait {
           list = List.insertIntoContext(self.moc, name: self.listName, ownerEmail: self.email)
        }
        
        // Then
        XCTAssertNotNil(list)
    }

    func testAddPlace() {
        // Given
        var place =  NSObject()
        
        // When
        moc.performChangesAndWait {
            place = Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName])
        }
        
        // Then
        XCTAssertNotNil(place)
    }
    
    func testAddPlaceToList() {
        // Given
        
        let f1 = NSFetchRequest(entityName: List.entityName)
        let f2 = NSFetchRequest(entityName: Place.entityName)
        
        // When
        let list = try! moc.executeFetchRequest(f1).first as? List
        let place = try! moc.executeFetchRequest(f2).first as? Place
        let placeList = place!.lists!.first!

        // Then
        XCTAssertEqual(place!.lists?.count, 1)
        XCTAssertEqual(placeList.name, list!.name)
        XCTAssertEqual(placeList.owner?.email, email)
        
    }
    
    override func tearDown() {
        moc = nil
        super.tearDown()
    }
    
}

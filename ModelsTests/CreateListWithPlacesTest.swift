//
//  ModelsTests.swift
//  ModelsTests
//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import XCTest
@testable import Models

class CreateListWithPlacesTest: XCTestCase {
    var moc: NSManagedObjectContext!
    let email = "test@email.com"
    let listName = "list"
    let placeName = "place"
    
    override func setUp() {
        super.setUp()
        moc = NSManagedObjectContext.chomperInMemoryTestContext()
    }
    
    override func tearDown() {
        moc = nil
        super.tearDown()
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
            place = Place.insertIntoContext(self.moc,
                location: nil,
                name: self.placeName,
                neighborhood: nil,
                price: nil,
                rating: nil,
                remoteId: "123",
                streetName: nil,
                state: nil,
                listNames: [self.listName]
            )}
        
        // Then
        XCTAssertNotNil(place)
    }
    
    func testAddPlaceToList() {
        // Given
        moc.performChangesAndWait {
            Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName])
        }
        
        let f1 = NSFetchRequest(entityName: List.entityName)
        let f2 = NSFetchRequest(entityName: Place.entityName)
        
        // When
        let list = try! moc.executeFetchRequest(f1).first as? List
        let place = try! moc.executeFetchRequest(f2).first as? Place
        let placeList = place!.lists!.first!

        // Then
        XCTAssertEqual(place!.lists?.count, 1)
        XCTAssertEqual(placeList.name, list!.name)
    }
    
    func testAddPlaceToExistingList() {
        
        // Given
        moc.performChangesAndWait {
            List.insertIntoContext(self.moc, name: self.listName, ownerEmail: "OwnerEmail")
        }
        
        moc.performChangesAndWait {
            Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName])
        }
        
        let f1 = NSFetchRequest(entityName: List.entityName)
        let f2 = NSFetchRequest(entityName: Place.entityName)

        
        let lists = try! moc.executeFetchRequest(f1)
        let list = lists.first as! List
        let place = try! moc.executeFetchRequest(f2).first as? Place
        let placeList = place!.lists!.first!
        
        // Then
        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(place!.lists?.count, 1)
        XCTAssertEqual(placeList.name, list.name)

    }
    
    func testAddToLists() {
        
        // Given
        moc.performChangesAndWait {
            Place.addToLists(self.moc, remoteId: "123", name: self.placeName, listNames: [self.listName])
        }
        
        // When
        let f1 = NSFetchRequest(entityName: List.entityName)
        let f2 = NSFetchRequest(entityName: Place.entityName)
        
        let lists = try! moc.executeFetchRequest(f1)
        let list = lists.first as! List
        let place = try! moc.executeFetchRequest(f2).first as? Place
        let placeList = place!.lists!.first!

        // Then
        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(place!.lists?.count, 1)
        XCTAssertEqual(placeList.name, list.name)

    }
    
}

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
        moc = setupTestingManagedContext()
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
    
    func testDeleteListAndPlace() {
        // Given
        moc.retainsRegisteredObjects = true

        let f1 = NSFetchRequest(entityName: List.entityName)
        let f2 = NSFetchRequest(entityName: Place.entityName)
        let list = try! moc.executeFetchRequest(f1).first as? List
        let listId = list?.objectID
        let placeId = list?.objectID

        
        // When
        moc.performChangesAndWait {
            self.moc.deleteObject(list!)
        }
        
        let inMemoryDeletedPlace = moc.objectRegisteredForID(placeId!)
        let inMemoryDeletedList = moc.objectRegisteredForID(listId!)
        
        let lists = try! moc.executeFetchRequest(f1)
        let deletedList = lists.first as? List
        let deletedPlace = try! moc.executeFetchRequest(f2).first as? Place

        // Then
        XCTAssertNil(inMemoryDeletedPlace)
        XCTAssertNil(inMemoryDeletedList)

        XCTAssertNil(deletedPlace)
        XCTAssertEqual(lists.count, 0)
        XCTAssertNil(deletedList)
    }
    
    func testDeletePlaceWithManyLists() {
        // Given
        moc.retainsRegisteredObjects = true
        let f1 = NSFetchRequest(entityName: List.entityName)
        let f2 = NSFetchRequest(entityName: Place.entityName)
        var place = NSObject()
        var deletedList = NSObject()
        var listId: NSManagedObjectID
        var placeId: NSManagedObjectID
        
        moc.performChangesAndWait {
            deletedList = List.insertIntoContext(self.moc, name: self.listName, ownerEmail: self.email)
            List.insertIntoContext(self.moc, name: "noDelete", ownerEmail: self.email)
        }
        moc.performChangesAndWait {
            place = Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName, "noDelete"])
        }
        listId = (deletedList as! List).objectID
        placeId = (place as! Place).objectID
        
 
        XCTAssertEqual((place as! Place).lists?.count, 2)
        
        // When
        moc.performChangesAndWait {
            self.moc.deleteObject(deletedList as! List)
        }
        let inMemoryDeletedList = moc.objectRegisteredForID(listId)
        let inMemoryPlace = moc.objectWithID(placeId)
        
        let lists = try! moc.executeFetchRequest(f1)
        let places = try! moc.executeFetchRequest(f2)
        let placeListSet = places.first?.lists
        let placeList = placeListSet!![placeListSet!!.startIndex.advancedBy(0)]
        
        // Then
        XCTAssertNil(inMemoryDeletedList)
        XCTAssertNotNil(inMemoryPlace)
        XCTAssertEqual(places.count, 1)
        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(lists.first?.name, "noDelete")
        XCTAssertEqual(places.first?.name, placeName)
        XCTAssertEqual(placeList.name, "noDelete")
        
        moc.refreshAllObjects()
    }
    
}

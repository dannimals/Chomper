//
//  ModelsTests.swift
//  ModelsTests
//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation
import XCTest
@testable import Common
@testable import Models

class CreateListWithPlacesTest: XCTestCase {
    
    var moc: NSManagedObjectContext!

    let address = "123 streetName"
    let city = "new york"
    let email = AppData.sharedInstance.ownerUserEmail
    let listName = "list"
    let location = CLLocation(latitude: 0, longitude: 0)
    let placeId = "123placeID"
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
    
    func testCreateList() {
        // Given
        var list = NSObject()
        
        // When
        moc.performChangesAndWait {
           list = List.insertIntoContext(self.moc, name: self.listName, ownerEmail: self.email)
        }
        
        // Then
        XCTAssertNotNil(list)
    }

    func testCreateListPlace() {
        // Given
        var listPlace: ListPlace!
        
        // When
        moc.performChangesAndWait {
            listPlace = ListPlace.insertIntoContext(self.moc, address: self.address, city: self.city, downloadImageUrl: nil, listName: self.listName, location: self.location, phone: nil, placeId: self.placeId, placeName: self.placeName, price: nil, notes: nil, rating: nil, state: nil) as ListPlace
        }
        
        let placeRequest = NSFetchRequest(entityName: Place.entityName)
        var error : NSError?
        let placeCount = moc.countForFetchRequest(placeRequest, error: &error)
        let listRequest = NSFetchRequest(entityName: List.entityName)
        let listCount = moc.countForFetchRequest(listRequest, error: &error)
        
        let place = listPlace.place
        let list = listPlace.list
        
        // Then
        XCTAssertNotNil(listPlace)
        XCTAssertEqual(listPlace.place?.name, placeName)
        XCTAssertEqual(listPlace.list?.name, listName)
        XCTAssertNil(error)
        XCTAssertEqual(placeCount, 1)
        XCTAssertEqual(listCount, 1)
        XCTAssertEqual(place?.listPlaces?.count, 1)
        XCTAssertEqual(list?.listPlaces?.count, 1)
        XCTAssertEqual(place?.name, placeName)
        XCTAssertEqual(list?.name, listName)
    }
    
    func testCreateMultipleListPlaces() {
        // Given
        var listPlace1: ListPlace!
        var listPlace2: ListPlace!
        
        // When
        moc.performChangesAndWait {
            listPlace1 = ListPlace.insertIntoContext(self.moc, address: self.address, city: self.city, downloadImageUrl: nil, listName: self.listName, location: self.location, phone: nil, placeId: self.placeId, placeName: self.placeName, price: nil, notes: nil, rating: nil, state: nil) as ListPlace
            listPlace2 = ListPlace.insertIntoContext(self.moc, address: self.address, city: self.city, downloadImageUrl: nil, listName: "secondList", location: self.location, phone: nil, placeId: self.placeId, placeName: self.placeName, price: nil, notes: nil, rating: nil, state: nil) as ListPlace
        }
        
        let placeRequest = NSFetchRequest(entityName: Place.entityName)
        var error : NSError?
        let placeCount = moc.countForFetchRequest(placeRequest, error: &error)
        let listRequest = NSFetchRequest(entityName: List.entityName)
        let listCount = moc.countForFetchRequest(listRequest, error: &error)
        
        let place1 = listPlace1.place
        let place2 = listPlace2.place
        let list1 = listPlace1.list
        let list2 = listPlace2.list
        
        // Then
        XCTAssertNotNil(listPlace1)
        XCTAssertNotNil(listPlace2)

        XCTAssertEqual(listPlace1.place?.name, placeName)
        XCTAssertEqual(listPlace2.place?.name, placeName)
        
        XCTAssertNotEqual(listPlace1.listName, listPlace2.listName)
        XCTAssertEqual(listPlace1.list?.name, listName)
        XCTAssertEqual(listPlace2.list?.name, "secondList")

        XCTAssertNil(error)
        XCTAssertEqual(placeCount, 1)
        XCTAssertEqual(listCount, 2)
        XCTAssertEqual(place1!.listPlaces?.count, 2)
        XCTAssertEqual(place2!.listPlaces?.count, 2)
        
        XCTAssertEqual(list1?.name, listName)
        XCTAssertEqual(list2?.name, "secondList")
        XCTAssertEqual(list1?.listPlaces?.count, 1)
        XCTAssertEqual(list2?.listPlaces?.count, 1)
        XCTAssertTrue(list1?.listPlaces?.first!.name == list2?.listPlaces?.first!.name)

        XCTAssertTrue(place1!.name == place2!.name)

    }
}

////
////  DeleteListsWithPlacesTest.swift
////  Chomper
////
////  Created by Danning Ge on 8/6/16.
////  Copyright © 2016 Danning Ge. All rights reserved.
////
//
//import XCTest
//@testable import Common
//@testable import Models
//
//class DeleteListsWithPlacesTest: XCTestCase {
//    var moc: NSManagedObjectContext!
//    let email = AppData.sharedInstance.ownerUserEmail
//    let listName = "list"
//    let placeName = "place"
//    
//    override func setUp() {
//        super.setUp()
//        moc = NSManagedObjectContext.chomperInMemoryTestContext()
//        moc.retainsRegisteredObjects = true
//    }
//    
//    override func tearDown() {
//        moc = nil
//        super.tearDown()
//    }
//    
//    func testDeleteListAndPlace() {
//        // Given
//        moc.performChangesAndWait {
//            List.insertIntoContext(self.moc, name: self.listName, ownerEmail: self.email)
//        }
//        moc.performChangesAndWait {
//            Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName])
//        }
//        
//        // When
//        let f1 = NSFetchRequest(entityName: List.entityName)
//        let f2 = NSFetchRequest(entityName: Place.entityName)
//        let list = try! moc.executeFetchRequest(f1).first as? List
//        let listId = list?.objectID
//        let placeId = list?.objectID
//        
//        moc.performChangesAndWait {
//            self.moc.deleteObject(list!)
//        }
//        
//        let inMemoryDeletedPlace = moc.objectRegisteredForID(placeId!)
//        let inMemoryDeletedList = moc.objectRegisteredForID(listId!)
//        
//        let lists = try! moc.executeFetchRequest(f1)
//        let deletedList = lists.first as? List
//        let deletedPlace = try! moc.executeFetchRequest(f2).first as? Place
//        
//        // Then
//        XCTAssertNil(inMemoryDeletedPlace)
//        XCTAssertNil(inMemoryDeletedList)
//        
//        XCTAssertEqual(lists.count, 0)
//        XCTAssertNil(deletedPlace)
//        XCTAssertNil(deletedList)
//    }
//    
//    func testDeletePlaceWithManyLists() {
//        // Given
//        let f1 = NSFetchRequest(entityName: List.entityName)
//        let f2 = NSFetchRequest(entityName: Place.entityName)
//        var place = NSObject()
//        var deletedList = NSObject()
//        var listId: NSManagedObjectID
//        var placeId: NSManagedObjectID
//        
//        moc.performChangesAndWait {
//            deletedList = List.insertIntoContext(self.moc, name: self.listName, ownerEmail: self.email)
//            List.insertIntoContext(self.moc, name: "noDelete", ownerEmail: self.email)
//        }
//        moc.performChangesAndWait {
//            place = Place.insertIntoContext(self.moc, location: nil, name: self.placeName, neighborhood: nil, price: nil, rating: nil, remoteId: "123", streetName: nil, state: nil, listNames: [self.listName, "noDelete"])
//        }
//        listId = (deletedList as! List).objectID
//        placeId = (place as! Place).objectID
//        
//        
//        XCTAssertEqual((place as! Place).lists?.count, 2)
//        
//        // When
//        moc.performChangesAndWait {
//            self.moc.deleteObject(deletedList as! List)
//        }
//        let inMemoryDeletedList = moc.objectRegisteredForID(listId)
//        let inMemoryPlace = moc.objectWithID(placeId)
//        
//        let lists = try! moc.executeFetchRequest(f1)
//        let places = try! moc.executeFetchRequest(f2)
//        let placeListSet = places.first?.lists
//        let placeList = placeListSet!![placeListSet!!.startIndex.advancedBy(0)]
//        
//        // Then
//        XCTAssertNil(inMemoryDeletedList)
//        XCTAssertNotNil(inMemoryPlace)
//        XCTAssertEqual(places.count, 1)
//        XCTAssertEqual(lists.count, 1)
//        XCTAssertEqual(lists.first?.name, "noDelete")
//        XCTAssertEqual(places.first?.name, placeName)
//        XCTAssertEqual(placeList.name, "noDelete")
//        
//        moc.refreshAllObjects()
//    }
//
//    
//}
//
//  MapPlacesViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 1/16/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Models

protocol MapPlacesDelegate: class {
    func didUpdateWithPlaces(places: [Place])
}

class MapPlacesViewModel: BaseViewModel {
    weak var delegate: MapPlacesDelegate?
    let backgroundContext: NSManagedObjectContext
    
    override init() {
        backgroundContext = NSManagedObjectContext.mainContext().createBackgroundContext()

        super.init()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: nil, using: mainContextUpdatedWithNotification)
    }
    
//    func mainContextUpdatedWithNotification(notification: Notification) {
//        var shouldUpdate = false
//        let note = ObjectsDidChangeNotification(note: notification)
//        for object in note.allObjects {
//            if object.isKind(of: Place.self) {
//                shouldUpdate = true
//                break
//            }
//        }
//        if shouldUpdate {
//            // TODO: should not do this as it is costly
//            fetchPlaces()
//        }
//    }
//    
    func mainContextUpdatedWithNotification(notification: Notification) {
        var places = [Place]()
        if notification.object as? NSManagedObjectContext == mainContext {
            for object in mainContext.registeredObjects {
                // TODO: wtf does this isDeleted flag not work
                if object.isKind(of: Place.self), !object.isDeleted {
                    places.append(object as! Place)
                }
            }
            delegate?.didUpdateWithPlaces(places: places)
        }
    }
    
    func fetchPlaces() {
        // TODO: need to instantiate these objects on the main context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Place.entityName)
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self] (result) in
            if let places = result.finalResult as? [Place] {
                self?.delegate?.didUpdateWithPlaces(places: places)
            }
        }
        try! backgroundContext.execute(asyncRequest)
    }
}

//
//  MapPlacesViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 1/16/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Models

protocol MapPlacesDelegate {
    func didUpdateWithPlaces(places: [Place])
}

class MapPlacesViewModel: BaseViewModel {
    var places: [Place]?
    var delegate: MapPlacesDelegate?
    
    override init() {

        super.init()
        self.places = try! mainContext.fetch(NSFetchRequest(entityName: Place.entityName))
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: nil, using: mainContextUpdatedWithNotification)

    }
    
    func mainContextUpdatedWithNotification(notification: Notification) {
        var shouldUpdate = false
        let note = ObjectsDidChangeNotification(note: notification)
        for object in note.allObjects {
            if object.isKind(of: Place.self) {
                shouldUpdate = true
                break
            }
        }
        if shouldUpdate {
            delegate?.didUpdateWithPlaces(places: fetchPlaces())
        }
    }
    func fetchPlaces() -> [Place] {
        return try! mainContext.fetch(NSFetchRequest(entityName: Place.entityName))
    }
}

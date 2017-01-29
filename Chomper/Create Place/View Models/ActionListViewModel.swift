//
//  ActionListViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 10/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class ActionListViewModel: BaseViewModelProtocol {
    enum Action: String {
        case none = ""
        case saveToFavorite = "Favorites"
        case addToList = "Add to List"
    }
    
    // MARK: - Properties
    
    var place: PlaceDetailsObjectProtocol
    var actions: [Action]
    private var mainContext: NSManagedObjectContext
    
    required init(place: PlaceDetailsObjectProtocol, mainContext: NSManagedObjectContext) {
        self.actions = [.none, .saveToFavorite, .addToList]
        self.mainContext = mainContext
        self.place = place
    }
    
    // MARK: - Helpers

    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return actions.count
    }
    
    func getTitleForPath(indexPath: IndexPath) -> String? {
        return actions[indexPath.row].rawValue
    }
    
    func saveToFavoriteList() {
        mainContext.performChanges { [unowned self] in
            let _ = ListPlace.insertIntoContext(self.mainContext, address: self.place.address, city: self.place.city, downloadImageUrl: self.place.imageUrl, listName: defaultSavedList, location: self.place.location, phone: self.place.phone, placeId: self.place.venueId, placeName: self.place.name, price: self.place.priceValue as NSNumber?, notes: self.place.userNotes, rating: self.place.ratingValue as NSNumber?, state: self.place.state)
        }
    }
}

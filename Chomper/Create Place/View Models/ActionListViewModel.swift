//
//  ActionListViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 10/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class ActionListViewModel: BaseViewModel {
    typealias ActionBlock = (() -> Void)?

    enum Action {
        case quickSave(action: ActionBlock)
        case addToList(action: ActionBlock)
        
        static let allValues = [quickSave, addToList]
    }
    
    // MARK: - Properties
    
    var place: PlaceDetailsObjectProtocol!
    var saveAction: ActionBlock!
    
    fileprivate var actions: [Action]!
    
    required init(place: PlaceDetailsObjectProtocol) {
        self.place = place
        self.actions = [
            Action.quickSave(action: nil),
            Action.addToList(action: nil)
        ]
 
        super.init()
 
        self.saveAction = { self.mainContext.performChanges { [unowned self] in
            let _ = ListPlace.insertIntoContext(self.mainContext, address: self.place.address, city: self.place.city, downloadImageUrl: self.place.imageUrl, listName: defaultSavedList, location: self.place.location, phone: self.place.phone, placeId: self.place.venueId, placeName: self.place.name, price: self.place.priceValue as NSNumber?, notes: self.place.userNotes, rating: self.place.ratingValue as NSNumber?, state: self.place.state)
            }
        }
    }
    
    // MARK: - Helpers
    
    func getActionForIndexPath(_ indexPath: IndexPath) -> Action {
        return actions[indexPath.row - 1]
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return actions.count + 1
    }
    
    func performAction(forAction action: Action) {
        switch action {
            case .quickSave(let action):
                action?()
            case .addToList(let action):
                action?()
        }
    }
    
    func getTitleForAction(_ action: Action) -> String {
        switch action {
            case .quickSave:
                return NSLocalizedString("Save", comment: "save")
            case .addToList:
                return NSLocalizedString("Add to List", comment: "add to list")
        }
    }
}

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
        case QuickSave(action: ActionBlock)
        case AddToList(action: ActionBlock)
        
        static let allValues = [QuickSave, AddToList]
    }
    
    // MARK: - Properties
    
    var place: PlaceDetailsObjectProtocol!
    var saveAction: ActionBlock!
    
    private var actions: [Action]!
    
    required init(place: PlaceDetailsObjectProtocol) {
        self.place = place
        self.actions = [
            Action.QuickSave(action: nil),
            Action.AddToList(action: nil)
        ]
 
        super.init()
 
        self.saveAction = { self.mainContext.performChanges { [unowned self] in
            ListPlace.insertIntoContext(self.mainContext, address: self.place.address, city: self.place.city, downloadImageUrl: self.place.imageUrl, listName: defaultSavedList, location: self.place.location, phone: self.place.phone, placeId: self.place.venueId, placeName: self.place.name, price: self.place.priceValue, notes: self.place.userNotes, rating: self.place.ratingValue, state: self.place.state)
            }
        }
    }
    
    // MARK: - Helpers
    
    func getActionForIndexPath(indexPath: NSIndexPath) -> Action {
        return actions[indexPath.row - 1]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return actions.count + 1
    }
    
    func performAction(forAction action: Action) {
        switch action {
            case .QuickSave(let action):
                action?()
            case .AddToList(let action):
                action?()
        }
    }
    
    func getTitleForAction(action: Action) -> String {
        switch action {
            case .QuickSave:
                return NSLocalizedString("Save", comment: "save")
            case .AddToList:
                return NSLocalizedString("Add to List", comment: "add to list")
        }
    }
    
}

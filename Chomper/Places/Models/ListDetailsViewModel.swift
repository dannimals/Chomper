//
//  Created by Danning Ge on 1/23/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import Models

class ListDetailsViewModel: BaseViewModelProtocol {
    private var mainContext: NSManagedObjectContext
    private var list: List?
    var listPlaces: [ListPlace]?
    var canDeleteList: Bool {
        return list?.name != defaultSavedList
    }
    var count: Int {
        return listPlaces?.count ?? 0
    }

    init(listId: NSManagedObjectID, mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.list = self.mainContext.object(with: listId) as? List
        self.listPlaces = list?.listPlaces?.sorted { $0.placeName < $1.placeName }
    }
    
    func deleteItemAtIndexPath(indexPath: IndexPath) -> GenericChomperError? {
        guard let item = listPlaces?[indexPath.row] else {
            return GenericChomperError.invalid(errorMessage: "Error occurred deleting place")
        }
        mainContext.performChanges { [unowned self] in
            self.mainContext.delete(item)
        }
        return nil
    }
    
    func deleteList() {
        guard let list = list else { return }
        mainContext.performChanges { [unowned self] in
            if let listPlaces = list.listPlaces {
                for listPlace in listPlaces {
                    self.mainContext.delete(listPlace)
                }
            }
            self.mainContext.delete(list)
        }

    }

    func getEditActionTitle(atIndexPath indexPath: IndexPath) -> String {
        return isMarkedVisited(indexPath: indexPath) ? "Not Visited" : "Visited"
    }
    
    func markVisitedAtIndexPath(indexPath: IndexPath) -> GenericChomperError? {
        guard let item = listPlaces?[indexPath.row] else {
            return GenericChomperError.invalid(errorMessage: "Error occurred marking place as visited")
        }
        let visited = item.place?.visited == NSNumber(value: 0) ? NSNumber(value: 1) : NSNumber(value: 0)
        mainContext.performChanges {
            item.place?.visited = visited
        }
        return nil
    }
    
    private func isMarkedVisited(indexPath: IndexPath) -> Bool {
        let item = listPlaces?[indexPath.row]
        return item?.place?.visited?.boolValue ?? false
    }
}

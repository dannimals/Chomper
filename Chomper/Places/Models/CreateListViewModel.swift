//
//  Created by Danning Ge on 1/23/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import Models

enum CreateListCheck: Equatable {
    case invalid(message: String)
    case valid
    
    static func ==(lhs: CreateListCheck, rhs: CreateListCheck) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .invalid), (.invalid, valid):
            return false
        default: return true
        }
    }
    
    var description: String? {
        switch self {
        case .invalid(message: let message):
            return message
        case .valid:
            return nil
        }
    }
}

class CreateListViewModel: BaseViewModelProtocol {
    private var backgroundContext: NSManagedObjectContext
    private var currentLists: [List]?
    
    init(mainContext: NSManagedObjectContext) {
        self.backgroundContext = mainContext.createBackgroundContext()
        self.backgroundContext.addNSManagedObjectContextDidSaveNotificationObserver(mainContext)
        do {
            currentLists = try self.backgroundContext.fetch(NSFetchRequest(entityName: List.entityName))
        } catch {
            currentLists = nil
        }
    }
    
    func saveList(listName: String) -> CreateListCheck {
        let check = isListValid(name: listName)
        if check == CreateListCheck.valid {
            backgroundContext.performChanges { [unowned self] in
                let _ = List.insertIntoContext(self.backgroundContext, name: listName, ownerEmail: AppData.sharedInstance.ownerUserEmail)
            }
        }
        return check
    }
    
    private func isListValid(name: String) -> CreateListCheck {
        if name.isEmpty || name.trimmingCharacters(in: CharacterSet.whitespaces).characters.count == 0 {
            return CreateListCheck.invalid(message: "List name cannot be empty")
        } else {
            if let lists = currentLists {
                for list in lists {
                    if list.name == name {
                        return CreateListCheck.invalid(message: "List already exists.")
                    }
                }
            } else {
                return CreateListCheck.invalid(message: "Sorry! Lists cannot be created at this time.")
            }
        }
        return CreateListCheck.valid
    }
}

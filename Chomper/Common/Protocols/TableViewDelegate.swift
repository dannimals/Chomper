//
//  TableViewDelegate.swift
//  Chomper
//
//  Created by Danning Ge on 7/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

protocol TableViewDelegate: class {
    associatedtype Object
    var tableView: UITableView! { get }
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>])
    func cellIdentifierForObject(object: Object) -> String
    func configureCell(cell: UITableViewCell, forObject: Object, atIndexPath: NSIndexPath)
}

extension TableViewDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]) {
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Update(let indexPath, _):
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Move(let indexPath, let newIndexPath):
                guard indexPath != newIndexPath else { return }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            
            case .InsertSection(let section):
                tableView.insertSections(section, withRowAnimation: .Automatic)
            case .DeleteSection(let section):
                tableView.deleteSections(section, withRowAnimation: .Automatic)
            }
        }
        tableView.endUpdates()
    }
    
    // MARK: - Override points
    
    func configureCell(cell: UITableViewCell, forObject: Object, atIndexPath: NSIndexPath) {}

}

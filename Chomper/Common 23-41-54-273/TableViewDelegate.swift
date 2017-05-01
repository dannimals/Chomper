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
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<Object>])
    func cellIdentifierForObject(_ object: Object) -> String
    func configureCell(_ cell: UITableViewCell, forObject: Object, atIndexPath: IndexPath)
}

extension TableViewDelegate {
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<Object>]) {
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .automatic)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .automatic)
            case .update(let indexPath, _):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .move(let indexPath, let newIndexPath):
                guard indexPath != newIndexPath else { return }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            case .insertSection(let section):
                tableView.insertSections(section, with: .automatic)
            case .deleteSection(let section):
                tableView.deleteSections(section, with: .automatic)
            }
        }
        tableView.endUpdates()
    }
    
    // MARK: - Override points
    
    func configureCell(_ cell: UITableViewCell, forObject: Object, atIndexPath: IndexPath) {}

}

//
//  TableDataProvider.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreData

//
// TableDataProvider protocol to be implemented by table views that use a NSFetchedResultsController

protocol TableDataProvider: class {
    associatedtype Object
    weak var tableView: UITableView! { get }
    func objectForIndexPath(indexPath: NSIndexPath) -> Object?
    func numberOfItemsInSection(section: Int) -> Int
    func numberOfSections() -> Int
    var sections: [NSFetchedResultsSectionInfo]? { get }
}

//
// Default implementation of TableDataProvider

extension TableDataProvider {
    var sections: [NSFetchedResultsSectionInfo]? {
        return nil
    }
    func numberOfSections() -> Int {
        return 1
    }
}



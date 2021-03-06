//
//  TableDataProvider.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

//
// TableDataProvider protocol to be implemented by table views that use a NSFetchedResultsController

protocol TableDataProvider: class {
    associatedtype Object
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object?
    func numberOfItemsInSection(_ section: Int) -> Int
    func numberOfSections() -> Int
    func nameOfSection(_ section: Int) -> String?
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
    
    func nameOfSection(_ section: Int) -> String? {
        return nil
    }
}



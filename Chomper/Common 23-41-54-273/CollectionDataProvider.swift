//
//  CollectionDataProvider.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

enum DataProviderUpdate<Object> {
    case insert(IndexPath)
    case update(IndexPath, Object)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
    
    case insertSection(IndexSet)
    case deleteSection(IndexSet)
}

//
// CollectionDataProvider protocol to be implemented by collection views that use a NSFetchedResultsController

protocol CollectionDataProvider: class {
    associatedtype Object
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object?
    func numberOfItemsInSection(_ section: Int) -> Int
    func numberOfSections() -> Int
    var sections: [NSFetchedResultsSectionInfo]? { get }
}

//
// Default implementation of TableDataProvider

extension CollectionDataProvider {
    var sections: [NSFetchedResultsSectionInfo]? {
        return nil
    }
    func numberOfSections() -> Int {
        return 1
    }
}

//
//  CollectionDataProvider.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreData

//
// CollectionDataProvider protocol to be implemented by collection views that use a NSFetchedResultsController

protocol CollectionDataProvider: class {
    associatedtype Object
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object?
    weak var collectionView: UICollectionView! { get set }
    func numberOfItemsInSection(section: Int) -> Int
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

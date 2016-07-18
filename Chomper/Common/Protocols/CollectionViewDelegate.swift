//
//  CollectionViewDelegate.swift
//  Chomper
//
//  Created by Danning Ge on 7/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

protocol CollectionViewDelegate: class {
    associatedtype Object
    var collectionView: UICollectionView? { get }
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>])
    
}

extension CollectionViewDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]) {
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                collectionView?.insertItemsAtIndexPaths([indexPath])
            case .Update(let indexPath, _):
                collectionView?.reloadItemsAtIndexPaths([indexPath])
            case .Move(let indexPath, let newIndexPath):
                guard indexPath != newIndexPath else { return }
                collectionView?.deleteItemsAtIndexPaths([indexPath])
                collectionView?.insertItemsAtIndexPaths([newIndexPath])
            case .Delete(let indexPath):
                collectionView?.deleteItemsAtIndexPaths([indexPath])
            case .InsertSection(let section):
                collectionView?.insertSections(section)
            case .DeleteSection(let section):
                collectionView?.deleteSections(section)

              // TODO: handle empty view
                
            }
        }
        //
        // Need to force refresh UI on visible cells 
        
        if let visibleCells = collectionView?.indexPathsForVisibleItems() {
            collectionView?.reloadItemsAtIndexPaths(visibleCells)
        }
    }
}


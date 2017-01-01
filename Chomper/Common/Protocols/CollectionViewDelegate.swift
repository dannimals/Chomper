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
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<Object>])
    
}

extension CollectionViewDelegate {
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<Object>]) {
        for update in updates {
            switch update {
            case .insert(let indexPath):
                collectionView?.insertItems(at: [indexPath])
            case .update(let indexPath, _):
                collectionView?.reloadItems(at: [indexPath])
            case .move(let indexPath, let newIndexPath):
                guard indexPath != newIndexPath else { return }
                collectionView?.deleteItems(at: [indexPath])
                collectionView?.insertItems(at: [newIndexPath])
            case .delete(let indexPath):
                collectionView?.deleteItems(at: [indexPath])
            case .insertSection(let section):
                collectionView?.insertSections(section)
            case .deleteSection(let section):
                collectionView?.deleteSections(section)

              // TODO: handle empty view
                
            }
        }
        //
        // Need to force refresh UI on visible cells 
        
        if let visibleCells = collectionView?.indexPathsForVisibleItems {
            collectionView?.reloadItems(at: visibleCells)
        }
    }
}


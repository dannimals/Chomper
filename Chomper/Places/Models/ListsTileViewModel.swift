//
//  MyPlacesTileViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

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
                
              // handle empty view
                
            }
        }
    }
}

class ListsTileViewModel<Delegate: CollectionViewDelegate>: NSObject, CollectionDataProvider, NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    
    weak var delegate: Delegate!
    private var fetchedResultsController: NSFetchedResultsController!
    private var updates = [DataProviderUpdate<Object>]()
    var sections: [NSFetchedResultsSectionInfo]? {
        return fetchedResultsController.sections
    }
    
    required init(delegate: Delegate, fetchedResultsController: NSFetchedResultsController) {
        self.delegate = delegate
        self.fetchedResultsController = fetchedResultsController
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        // Is there a better place to performFetch()??
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object? {
        if fetchedResultsController.checkBoundsForIndexPath(indexPath) {
            return fetchedResultsController.objectAtIndexPath(indexPath) as? Object
        }
        return nil
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        //
        // Add a "+" cell in collectionView
        guard let sec = sections?[section] else { return 1 }
        return sec.numberOfObjects + 1
    }
    
    func numberOfSections() -> Int {
        return max(1, sections?.count ?? 0)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        updates.removeAll()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            guard let indexPath = newIndexPath else { fatalError("Insert: IndexPath should be not nil") }
            updates.append(.Insert(indexPath))
        case .Update:
            guard let indexPath = indexPath, object = objectAtIndexPath(indexPath) else { return }
            updates.append(.Update(indexPath, object))
        case .Move:
            guard let indexPath = indexPath, newIndexPath = newIndexPath else { fatalError("Move: IndexPath/newIndexPath should be not nil") }
            if indexPath != newIndexPath {
                updates.append(.Move(indexPath, newIndexPath))
            }
        case .Delete:
            guard let indexPath = indexPath else { fatalError("Delete: IndexPath should be not nil") }
            updates.append(.Delete(indexPath))
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch (type) {
        case .Insert:
            updates.append(.InsertSection(NSIndexSet(index: sectionIndex)))
        case .Delete:
            updates.append(.DeleteSection(NSIndexSet(index: sectionIndex)))
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate.dataProviderDidUpdate(updates)
    }
    
}


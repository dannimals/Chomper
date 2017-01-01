//
//  MyPlacesTileViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class ListsTileViewModel<Delegate: CollectionViewDelegate>: NSObject, CollectionDataProvider, NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    
    weak var delegate: Delegate!
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    fileprivate var updates = [DataProviderUpdate<Object>]()
    var sections: [NSFetchedResultsSectionInfo]? {
        return fetchedResultsController.sections
    }
    
    required init(delegate: Delegate, fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate = delegate
        self.fetchedResultsController = fetchedResultsController
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        // Is there a better place to performFetch()??
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object? {
        if fetchedResultsController.checkBoundsForIndexPath(indexPath) {
            return fetchedResultsController.object(at: indexPath) as? Object
        }
        return nil
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        //
        // Add an extra "+" cell in collectionView
        
        guard let sec = sections?[section] else { return 1 }
        return sec.numberOfObjects + 1
    }
    
    func numberOfSections() -> Int {
        return max(1, sections?.count ?? 0)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Insert: IndexPath should be not nil") }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath, let object = objectAtIndexPath(indexPath) else { return }
            updates.append(.update(indexPath, object))
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { fatalError("Move: IndexPath/newIndexPath should be not nil") }
            if indexPath != newIndexPath {
                updates.append(.move(indexPath, newIndexPath))
            }
        case .delete:
            guard let indexPath = indexPath else { fatalError("Delete: IndexPath should be not nil") }
            updates.append(.delete(indexPath))
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch (type) {
        case .insert:
            updates.append(.insertSection(IndexSet(integer: sectionIndex)))
        case .delete:
            updates.append(.deleteSection(IndexSet(integer: sectionIndex)))
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate.dataProviderDidUpdate(self.updates)
    }
    
}


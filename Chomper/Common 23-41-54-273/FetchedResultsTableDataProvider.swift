//
//  FetchedResultsTableDataProvider.swift
//  Chomper
//
//  Created by Danning Ge on 8/13/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class FetchedResultsTableDataProvider<Delegate: TableViewDelegate>: NSObject, TableDataProvider, NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    weak var delegate: Delegate!
    var sections: [NSFetchedResultsSectionInfo]? {
        get {
            return fetchedResultsController.sections
        }
    }
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    fileprivate var updates = [DataProviderUpdate<Object>]()
    
    required init(tableViewDelegate: Delegate, frc: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate = tableViewDelegate
        fetchedResultsController = frc
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    
    // MARK: - TableDataProvider methods
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object? {
        if fetchedResultsController.checkBoundsForIndexPath(indexPath) {
            return fetchedResultsController.object(at: indexPath) as? Object
        }
        return nil
    }
    
    func numberOfSections() -> Int {
        return sections?.count ?? 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return sections?[section].numberOfObjects ?? 0
    }
    
    func nameOfSection(_ section: Int) -> String? {
        return sections?[section].name
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
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
        switch type {
        case .insert:
            updates.append(.insertSection(IndexSet(integer: sectionIndex)))
        case .delete:
            updates.append(.deleteSection(IndexSet(integer: sectionIndex)))
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.dataProviderDidUpdate(updates)
    }
}

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
    private var fetchedResultsController: NSFetchedResultsController!
    private var updates = [DataProviderUpdate<Object>]()
    
    required init(tableViewDelegate: Delegate, frc: NSFetchedResultsController) {
        delegate = tableViewDelegate
        fetchedResultsController = frc
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    
    // MARK: - TableDataProvider methods
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object? {
        if fetchedResultsController.checkBoundsForIndexPath(indexPath) {
            return fetchedResultsController.objectAtIndexPath(indexPath) as? Object
        }
        return nil
    }
    
    func numberOfSections() -> Int {
        return sections?.count ?? 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return sections?[section].numberOfObjects ?? 0
    }
    
    func nameOfSection(section: Int) -> String? {
        return sections?[section].name
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
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
        switch type {
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

//
//  NSFetchedResultsController+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//


extension NSFetchedResultsController {
    
    public func checkBoundsForIndexPath(indexPath: NSIndexPath) -> Bool {
        if let sections = sections {
            let section = indexPath.section
            
            if section < sections.count {
                let row = indexPath.row
                return row < sections[section].numberOfObjects
            }
        }
        return false
    }
    
    
}
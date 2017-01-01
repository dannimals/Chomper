//
//  Utilities.swift
//  Chomper
//
//  Created by Danning Ge on 6/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
import Foundation

extension Sequence where Iterator.Element: AnyObject {
    public func containsObjectIdenticalTo(_ object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}

extension URL {
    static var documentsDirectory: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
}

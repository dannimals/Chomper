//
//  Utilities.swift
//  Chomper
//
//  Created by Danning Ge on 6/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreData
import Foundation

extension SequenceType where Generator.Element: AnyObject {
    public func containsObjectIdenticalTo(object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}
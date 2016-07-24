//
//  NSLayoutConstraint+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/24/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

extension NSLayoutConstraint {
    
    public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activateConstraints(constraints)
    }
}

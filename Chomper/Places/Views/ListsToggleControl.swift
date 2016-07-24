//
//  ListsToggleControl.swift
//  Chomper
//
//  Created by Danning Ge on 7/24/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsToggleControl: ToggleControl {
    var labelTappedAction: ((index: Int) -> Void)?
    
    override func labelTappedWithIndex(index: Int) {
        labelTappedAction?(index: index)
    }
}

//
//  ListsToggleControl.swift
//  Chomper
//
//  Created by Danning Ge on 7/24/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsToggleControl: ToggleControl {
    var labelTappedAction: ((_ index: Int) -> Void)?
    
    override func labelTappedWithIndex(_ index: Int) {
        labelTappedAction?(index)
    }
}

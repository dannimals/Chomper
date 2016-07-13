//
//  MyPlacesTileViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

protocol CollectionViewDelegate: class {
    associatedtype Object
}

class ListsTileViewModel<Delegate: CollectionViewDelegate>: NSObject, CollectionDataProvider {
    typealias Object = Delegate.Object
    
    weak var delegate: Delegate!

    required init(delegate: Delegate) {
        self.delegate = delegate
        super.init()
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object? {
        return nil
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return 5
    }
    
}


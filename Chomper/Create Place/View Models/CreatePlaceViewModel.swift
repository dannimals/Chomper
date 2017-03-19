//
//  CreatePlaceViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import WebServices

struct CreatePlaceViewModel {
    fileprivate(set) var results: [SearchPlace]!

    init(results: [SearchPlace]) {
        self.results = results
    }
    
    // MARK: - Helpers
    
    func numberOfRows() -> Int {
        return results.count
    }
    
 }

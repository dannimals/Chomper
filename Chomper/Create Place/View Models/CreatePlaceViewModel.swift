//
//  CreatePlaceViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

struct CreatePlaceViewModel {
    fileprivate(set) var results: [SearchResult]!

    init(results: [SearchResult]) {
        self.results = results
    }
    
    // MARK: - Helpers
    
    func numberOfRows() -> Int {
        return results.count
    }
    
 }

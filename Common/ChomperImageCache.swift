//
//  ChomperImageCache.swift
//  Chomper
//
//  Created by Danning Ge on 8/24/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

public protocol ChomperImageCacheProtocol: class {
    //subscript(key: AnyObject) -> AnyObject? { get set }
}

open class ChomperImageCache: NSCache<AnyObject, AnyObject>, ChomperImageCacheProtocol {
    
    open static func createImageCache() -> ChomperImageCache {
        let cache = ChomperImageCache()
        cache.name = "ChomperImageCache"
        cache.countLimit = 20
        cache.totalCostLimit = 10 * 1024 * 1024
        return cache
    }
}


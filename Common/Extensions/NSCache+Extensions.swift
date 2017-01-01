//
//  NSCache+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 8/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

extension NSCache {
   public subscript(key: AnyObject) -> AnyObject? {
        get {
            return (self as! NSCache<AnyObject, AnyObject>).object(forKey: key)
        }
        set {
            if let value = newValue {
                (self as! NSCache<AnyObject, AnyObject>).setObject(value, forKey: key)
            } else {
                (self as! NSCache<AnyObject, AnyObject>).removeObject(forKey: key)
            }
        }
    }
}

//
//  DependencyInjector.swift
//  Chomper
//
//  Created by Danning Ge on 6/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Foundation

open class DependencyInjector {
    // MARK: - Instance variables
    
    fileprivate var _singletons = [String: AnyObject]()
    
    // MARK: - Static properties
    
    /**
     The shared `DependencyInjector` instance.
     */
    open static let sharedInstance: DependencyInjector = {
        return DependencyInjector()
    }()
    
    // MARK: - Methods
    
    /**
     Stores and associates a singleton object with a protocol.
     
     *Usage*:
     
     `injector.setSingleton(someObject, proto: "\(SomeProtocol.self)")`
     
     - parameter singleton: The singleton to store a reference to.
     - parameter proto: The protocol to associate the singleton with.
     */
    open func setSingleton(_ singleton: AnyObject, proto: String) {
        _singletons[proto] = singleton
    }
    
    /**
     Retrieves a singleton object that was previously was associated with a protocol.
     
     *Usage*:
     
     `injector.singletonForProtocol("\(SomeProtocol.self)")`
     
     - parameter proto: The protocol of the singleton object to retrieve.
     
     - returns: The singleton object, or nil if one does not exist for the specified protocol.
     */
    open func singletonForProtocol(_ proto: String) -> AnyObject {
        return _singletons[proto]!
    }
    
    /**
     Convenience method for singletonForProtocol: and setSingleton:proto:
     */
    subscript(proto: String) -> AnyObject {
        get {
            return self.singletonForProtocol(proto)
        }
        
        set {
            self.setSingleton(newValue, proto: proto)
        }
    }


}

//
//  AppData.swift
//  Chomper
//
//  Created by Danning Ge on 8/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

open class AppData {
    
    fileprivate var defaults: UserDefaults
    
    open var ownerUserEmail: String {
        get {
            return defaults.object(forKey: ownerEmail) as! String
        }
        set {
            defaults.setValue(newValue, forKey: ownerEmail)
        }
    }
    

    // MARK: - Initializers
    
    open static let sharedInstance: AppData = {
        // TODO: configure with suiteName in the future
        let defaults = UserDefaults.standard
        return AppData(defaults: defaults)
    }()
    
    fileprivate init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

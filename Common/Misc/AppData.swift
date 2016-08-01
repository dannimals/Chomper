//
//  AppData.swift
//  Chomper
//
//  Created by Danning Ge on 8/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

public class AppData {
    
    private var defaults: NSUserDefaults
    
    public var ownerUserEmail: String {
        get {
            return defaults.objectForKey(ownerEmail) as! String
        }
        set {
            defaults.setValue(newValue, forKey: ownerEmail)
        }
    }
    

    // MARK: - Initializers
    
    public static let sharedInstance: AppData = {
        // TODO: configure with suiteName in the future
        let defaults = NSUserDefaults.standardUserDefaults()
        return AppData(defaults: defaults)
    }()
    
    private init(defaults: NSUserDefaults) {
        self.defaults = defaults
    }
}

//
//  ChomperLocationManager.swift
//  Chomper
//
//  Created by Danning Ge on 6/28/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


public protocol ChomperLocationManagerProtocol {
    var locationManager: CLLocationManager { get }
}

public class ChomperLocationManager: NSObject, CLLocationManagerDelegate, ChomperLocationManagerProtocol {
    
    public var locationManager = CLLocationManager()
    
    // MARK: - Class methods
    
    public static func createChomperLocationManager() -> ChomperLocationManager {
        let manager = ChomperLocationManager()
        manager.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.locationManager.delegate = manager
        return manager
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error)")
    }
    
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations \(locations.first)")
    }
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }

}

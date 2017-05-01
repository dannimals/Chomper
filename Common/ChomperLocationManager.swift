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

open class ChomperLocationManager: NSObject, CLLocationManagerDelegate, ChomperLocationManagerProtocol {
    
    open var locationManager = CLLocationManager()
    
    // MARK: - Class methods
    
    open static func createChomperLocationManager() -> ChomperLocationManager {
        let manager = ChomperLocationManager()
        manager.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.locationManager.delegate = manager
        return manager
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
    
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations \(locations.first)")
    }
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }

}

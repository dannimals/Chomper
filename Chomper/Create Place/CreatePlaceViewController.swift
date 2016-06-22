//
//  CreateNewPlaceViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import Models
import WebServices

class CreatePlaceViewController: UIViewController, BaseViewControllerProtocol, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        let location = CLLocation(latitude: 40.7,longitude: -74)
//        webService.getPlacesNearLocation(location, searchTerm: nil) { (data, response, error) in
//            if error == nil {
//                if let data = data {
//                    if let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) {
//                        print(jsonString)
//                    }
//                }
//            }
//        }
        

        
        getLocation()
    }
    
    // MARK: - Handlers
    
    private func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        } else if authStatus == .Denied || authStatus == .Restricted {
            alertWithCancelButton(confirmButton: NSLocalizedString("Open Settings", comment: "open settings"),
                                  title: NSLocalizedString("Location Access Disabled", comment: "Location access disabled"),
                                  message: NSLocalizedString("In order to find nearby places, Chomper needs access to your location while using the app.",
                                    comment: "location services disabled")) { (value) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error)")
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations \(locations.first)")
        // TDOO: Call current webService for places in location here
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
}


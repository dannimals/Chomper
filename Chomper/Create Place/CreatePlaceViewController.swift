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

struct SearchResult {
    var name: String
    var address: String
    var location: CLLocation
    var price: Double?
    var rating: Double?
    var venueId: String
}

class CreatePlaceViewController: UIViewController, BaseViewControllerProtocol, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var resultPlaces = [SearchResult]()
    
    private var tableVC: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        tableVC = UITableViewController()
        view.addSubview(tableVC.view)
        tableVC.tableView.frame = view.frame
        tableVC.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let location = CLLocation(latitude: 40.7,longitude: -74)

        getRecommendedPlacesNearLocation(location, searchTerm: nil)
        // get the location and call getRecommendedPlacesNear
    }
    
    // MARK: - Handlers
    
    private func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?) {
        webService.getRecommendedPlacesNearLocation(location, searchTerm: searchTerm) { [weak self] (json, response, error) in
            if error == nil {
                if let json = json {
                    self?.resultPlaces.removeAll()
                    print(json)
                    
                    if let response = json["response"]["groups"].array, let results = response.first?["items"].dictionary {
                        print(results)
//                        for result in results {
//                            let venue = result.1
//                            let place = SearchResult(name: <#T##String#>, address: <#T##String#>, location: <#T##CLLocation#>, price: <#T##Double?#>, rating: <#T##Double?#>, venueId: <#T##String#>)
//                        }
                    }


                    
                }
            }
        }

    }
    
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


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
import SwiftyJSON
import WebServices

struct SearchResult {
    var name: String
    var address: String?
    var location: CLLocation
    var price: Double?
    var rating: Double?
    var venueId: String
}



struct CreatePlaceViewModel {
    
    private(set) var _results: [SearchResult]!
    
    init(jsonArray: [JSON]) {
        parseJson(jsonArray)
    }
    
    // MARK: - Helpers
    
    func numberOfRows() -> Int {
        return _results.count
    }
    
    private mutating func parseJson(results: [JSON]) {
        _results = [SearchResult]()
        for result in results {
            let venue = result["venue"]
            let name = venue["name"].string!
            let id = venue["id"].string!
            let address = venue["location"]["address"].string
            let location = CLLocation(latitude: venue["location"]["lat"].double!, longitude: venue["location"]["lng"].double!)
            let rating = venue["rating"].double
            let price = venue["price"]["tier"].double
            let place = SearchResult(name: name, address: address, location: location, price: price, rating: rating, venueId: id)
            _results.append(place)
        }

    }
}



class CreatePlaceViewController: UIViewController, BaseViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var viewModel: CreatePlaceViewModel?
    var searchView: UIView!
    
    private var tableVC: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        tableVC = UITableViewController()
        tableVC.tableView.dataSource = self
        tableVC.tableView.delegate = self
        tableVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableVC.view)
        tableVC.tableView.tableFooterView = UIView()
        tableVC.tableView.separatorStyle = .None
        registerNibs()
        
        searchView = UIView()
        searchView.backgroundColor = UIColor.orangeColor()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        
        
        let views: [String: AnyObject] = [
            "searchView": searchView,
            "tableVC": tableVC.view
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[searchView(60)][tableVC]|",
            options: [],
            metrics: nil,
            views: views)
        )
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[searchView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[tableVC]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)   {
        super.init(nibName: nil, bundle: nil)
        
        let location = CLLocation(latitude: 40.7,longitude: -74)
        getRecommendedPlacesNearLocation(location, searchTerm: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Handlers
    
    private func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?) {
        webService.getRecommendedPlacesNearLocation(location, searchTerm: searchTerm) { [weak self] (json, response, error) in
            if error == nil {
                if let json = json {
                    if let response = json["response"]["groups"].array, let results = response.first?["items"].array {
                        self?.viewModel = CreatePlaceViewModel(jsonArray: results)
                        self?.tableVC.tableView.reloadData()
                    }
                }
            } else {
                self?.viewModel = nil
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
    
    // MARK: - Helpers
    
    func registerNibs() {
        tableVC.tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as? PlaceTableViewCell, let object = viewModel?._results[indexPath.row] else {fatalError("Error config PlaceTableViewCell")}
                cell.configureCell(withObject: object)
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
    
    
}

extension CreatePlaceViewController: CLLocationManagerDelegate {
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


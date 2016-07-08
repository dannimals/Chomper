//
//  CreateNewPlaceViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import GoogleMaps
import Models
import SwiftyJSON
import WebServices

class CreatePlaceViewController: UIViewController, BaseViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var viewModel: CreatePlaceViewModel?
    var searchView: CreatePlaceSearchView!
    private var searchLocationCoord: CLLocationCoordinate2D?
    private var searchTerm: String?

    private var tableVC: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        //
        // Set up tableViewController
        
        tableVC = UITableViewController()
        tableVC.tableView.dataSource = self
        tableVC.tableView.delegate = self
        tableVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableVC.view)
        tableVC.tableView.keyboardDismissMode = .OnDrag
        tableVC.tableView.tableFooterView = UIView()
        tableVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        tableVC.tableView.separatorStyle = .None
        registerNibs()
        
        //
        // Set up search view
        
        searchView = CreatePlaceSearchView()
        searchView.cancelAction = { [weak self] in
            
            self?.searchView.cancelSearch()
            self?.searchLocationCoord = nil
        }
        searchView.searchAction = { [weak self] in
            guard let coord = self?.searchLocationCoord else { return }
            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            self?.getRecommendedPlacesNearLocation(location, searchTerm: self?.searchView.textSearch.text)
        }
        
        searchView.textSearch.delegate = self
        searchView.locationSearch.delegate = self
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
    
        let views: [String: AnyObject] = [
            "searchView": searchView,
            "tableVC": tableVC.view
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[searchView][tableVC]|",
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
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[searchView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyBoardDismiss), name: UIKeyboardWillHideNotification, object: nil)
        
        // 
        // Call webService for recommended places near current location

        guard let location = locationManager.location else { return }
        getRecommendedPlacesNearLocation(location, searchTerm: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)   {
        super.init(nibName: nil, bundle: nil)
        getLocation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Handlers
    
    private func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?) {
        webService.getRecommendedPlacesNearLocation(location, searchTerm: searchTerm) { [weak self] (places, response, error) in
            if error == nil, let places = places {
                self?.viewModel = CreatePlaceViewModel(results: places)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tableVC.tableView.reloadData()
                })
                
            } else {
                self?.viewModel = nil
                // TODO: display no results placeholder view
            }
        }

    }
    
    // MARK: - Helpers
    
    func getLocation() {
        let CM = DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperLocationManagerProtocol.self)")
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            CM.locationManager.requestWhenInUseAuthorization()
            return
        } else if authStatus == .Denied || authStatus == .Restricted {
            // TODO: Handle this
            let alert = UIAlertController(title: NSLocalizedString("Location Access Disabled", comment: "Location access disabled"), message: NSLocalizedString("In order to find nearby places, Chomper needs access to your location while using the app.", comment: "location services disabled"), preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel, handler: { (action) in
                //
            })
            
            alert.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: NSLocalizedString("Open Settings", comment: "Open Settings"), style: .Default, handler: { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            
            alert.addAction(confirmAction)
        }
    }
    
    // MARK: - Helpers
    
    func registerNibs() {
        tableVC.tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
    }
    
    func keyBoardDismiss() {
        searchView.cancelSearch()
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as? PlaceTableViewCell, let object = viewModel?.results[indexPath.row] else {fatalError("Error config PlaceTableViewCell")}
        cell.configureCell(withObject: object)
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let object = viewModel?.results[indexPath.row] else { fatalError("Error selected object is invalid") }
        let vc = PlaceDetailsViewController(venue: object)
        let nc = BaseNavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
}

extension CreatePlaceViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searchView.activateSearch()
    }
}

extension CreatePlaceViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let vc = LocationSearchViewController()
        vc.searchAction = { [weak self] (name, coordinate) in
            self?.searchView.locationSearch.text = name
            self?.searchLocationCoord = coordinate
        }
        vc.searchTerm = searchView.locationSearch.text
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
  
}



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
    var searchController: UISearchController!
    var resultsViewController: GMSAutocompleteResultsViewController!

    
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
        tableVC.tableView.tableFooterView = UIView()
        tableVC.tableView.separatorStyle = .None
        registerNibs()
        
        //
        // Set up googleMaps address search
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    
        let views: [String: AnyObject] = [
            "tableVC": tableVC.view,
            "topLayoutGuide": self.topLayoutGuide
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[topLayoutGuide][tableVC]|",
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
        
        guard let location = locationManager.location else { return }
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
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self?.tableVC.tableView.reloadData()

                        })
                    }
                }
            } else {
                self?.viewModel = nil
                // TODO: display no results placeholder view
            }
        }

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

extension CreatePlaceViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //
    }
}

extension CreatePlaceViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController, didAutocompleteWithPlace place: GMSPlace) {
        searchController?.active = false
        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}


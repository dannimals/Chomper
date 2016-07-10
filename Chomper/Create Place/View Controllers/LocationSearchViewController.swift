//
//  LocationSearch.swift
//  Chomper
//
//  Created by Danning Ge on 7/5/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import GoogleMaps
import UIKit

class LocationSearchViewController: UIViewController, BaseViewControllerProtocol {
    
    // MARK: - Properties
    
    private var resultsViewController: GMSAutocompleteResultsViewController?
    private var searchBar: UISearchBar!
    private var searchController: UISearchController!
    
    var searchAction: ((locationName: String, coordinate: CLLocation) -> Void)?
    var searchTerm: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = resultsViewController
        searchBar = searchController!.searchBar
        searchBar.placeholder = NSLocalizedString("Search locations", comment: "Location search")
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController!.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchController.active = true
    }
    
    // MARK: - Helpers
    
    func dismissVC() {
        searchBar.resignFirstResponder()
        searchController!.dismissViewControllerAnimated(true, completion: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension LocationSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController, didAutocompleteWithPlace place: GMSPlace) {
        searchController?.searchBar.text = place.name
        searchAction?(locationName: searchController?.searchBar.text ?? "", coordinate: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        dismissVC()

        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.coordinate)
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

extension LocationSearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(searchController: UISearchController) {
        searchBar.becomeFirstResponder()
        searchBar.text = searchTerm
    }

}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissVC()
    }
    
    
}


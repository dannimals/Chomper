//
//  LocationSearch.swift
//  Chomper
//
//  Created by Danning Ge on 7/5/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import GoogleMaps

class LocationSearchViewController: UIViewController, BaseViewControllerProtocol {
    
    // MARK: - Properties
    
    fileprivate var resultsViewController: GMSAutocompleteResultsViewController?
    fileprivate var searchBar: UISearchBar!
    fileprivate var searchController: UISearchController!
    
    var searchAction: ((_ locationName: String, _ coordinate: CLLocation) -> Void)?
    var searchTerm: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    // MARK: - Helpers
    
    func dismissVC() {
        searchBar.resignFirstResponder()
        searchController!.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
}

extension LocationSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.searchBar.text = place.name
        searchAction?(searchController?.searchBar.text ?? "", CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        dismissVC()

        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress ?? "")
        print("Place attributions: ", place.coordinate)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension LocationSearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchBar.becomeFirstResponder()
        searchBar.text = searchTerm
    }

}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissVC()
    }
    
    
}


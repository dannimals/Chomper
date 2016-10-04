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

class CreatePlaceViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var viewModel: CreatePlaceViewModel?
    var searchView: CreatePlaceSearchView!
    private var loadingView: UIView!
    private var loadingLabel: UILabel!
    private var searchLocationCoord: CLLocation?
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
        tableVC.refreshControl = UIRefreshControl()
        tableVC.refreshControl?.tintColor = UIColor.orangeColor()
        tableVC.refreshControl?.enabled = true
        tableVC.refreshControl?.addTarget(self, action: #selector(handleRefresh), forControlEvents: .ValueChanged)
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
            guard let location = self?.searchLocationCoord ?? self?.locationManager.location else { return }
            self?.getRecommendedPlacesNearLocation(location, searchTerm: self?.searchView.textSearch.text)
        }
        
        searchView.textSearch.delegate = self
        searchView.locationSearch.delegate = self
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        
        //
        // Set up loading view
        
        createLoadingView()
        
        let views: [String: AnyObject] = [
            "searchView": searchView,
            "tableVC": tableVC.view,
            "loadingView": loadingView
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[searchView][tableVC]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[searchView][loadingView]|",
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
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[loadingView]|",
            options: [],
            metrics: nil,
            views: views)
            
        )

        
        // 
        // Call webService for recommended places near current location

        guard let location = locationManager.location else { return }
        getRecommendedPlacesNearLocation(location, searchTerm: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if searchView.layer.shadowPath == nil {
            searchView.setShadow()
        }

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)   {
        super.init(nibName: nil, bundle: nil)
        checkLocationPermission()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Handlers
    
    private func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, showLoading: Bool = true) {
        showLoadingView(showLoading)
        webService.getRecommendedPlacesNearLocation(location, searchTerm: searchTerm) { [weak self] (places, response, error) in
            if error == nil, let places = places {
                self?.viewModel = CreatePlaceViewModel(results: places)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tableVC.tableView.reloadData()
                    self?.showLoadingView(false)
                    self?.tableVC.refreshControl?.endRefreshing()
                })
                
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.showLoadingView(false)
                    self?.viewModel = nil
                    self?.tableVC.refreshControl?.endRefreshing()
                })

                // TODO: display no results placeholder view
            }
        }

    }
    
    func handleRefresh() {
        guard let location = searchLocationCoord ?? locationManager.location else { return }
        getRecommendedPlacesNearLocation(location, searchTerm: searchView.textSearch.text, showLoading: false)
    }

    
    // MARK: - Helpers
    
    func checkLocationPermission() {
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
    
    func showLoadingView(show: Bool = false) {
        if show {
            loadingView.hidden = false
            loadingLabel.alpha = 0
            UIView.animateWithDuration(1.0, delay: 0.0, options: [.Repeat, .Autoreverse], animations: { [weak self] in
                self?.loadingLabel.alpha = 1
                }, completion: nil)
            view.bringSubviewToFront(loadingView)
        } else {
            UIView.animateWithDuration(0.4, animations: { [weak self] in
                self?.loadingView.hidden = true
            })
        }
    }
    
    func createLoadingView() {
        loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.backgroundColor = UIColor.whiteColor()
        loadingView.hidden = true
        
        loadingLabel = UILabel()
        loadingView.addSubview(loadingLabel)
        loadingLabel.text = NSLocalizedString("Loading", comment: "Loading")
        loadingLabel.textColor = UIColor.orangeColor()
        loadingLabel.font = UIFont.chomperFontForTextStyle("h4")
       
        NSLayoutConstraint.useAndActivateConstraints([
            loadingLabel.centerYAnchor.constraintEqualToAnchor(loadingView.centerYAnchor),
            loadingLabel.centerXAnchor.constraintEqualToAnchor(loadingView.centerXAnchor)
        ])
    }
    
    func quickSave(indexPath: NSIndexPath) {
        guard let place = viewModel?.results[indexPath.row] else { fatalError("Error selected object is invalid") }
        self.mainContext.performChanges {
            ListPlace.insertIntoContext(self.mainContext, address: place.address, city: place.city, downloadImageUrl: place.imageUrl, listName: defaultSavedList, location: place.location, phone: place.phone, placeId: place.venueId, placeName: place.name, price: place.priceValue, notes: place.userNotes, rating: place.ratingValue, state: place.state)
        }
        tableVC.tableView.setEditing(false, animated: true)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as? PlaceTableViewCell, let object = viewModel?.results[indexPath.row] else {fatalError("Error config PlaceTableViewCell")}
        cell.configureCell(withObject: object)
        if let image = imageCache[object.venueId ?? ""] as? UIImage {
            cell.placeImageView.image = image
        } else {
            if let imageUrl = object.imageUrl, url = NSURL(string: imageUrl) {
                NSURLSession.sharedSession().dataTaskWithURL(url) { [weak self] (data, response, error) in
                    if error == nil, let data = data,
                        let image = UIImage(data: data) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self?.imageCache[object.venueId ?? ""] = image
                            if cell.imageUrl == object.imageUrl {
                                UIView.animateWithDuration(0.2, animations: {
                                    cell.placeImageView.image = image
                                })
                            }
                        }
                    }
                }.resume()

            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let object = viewModel?.results[indexPath.row] else { fatalError("Error selected object is invalid") }
        let vc = PlaceDetailsViewController(place: object)
        let nc = BaseNavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        quickSave(indexPath)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Save", comment: "quick save")) { [unowned self] (_, indexPath) in
            self.quickSave(indexPath)
        }
        save.backgroundColor = UIColor.orangeColor()
        return [save]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}

extension CreatePlaceViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searchView.enableSearch()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let location = searchLocationCoord ?? locationManager.location else { return false }
        getRecommendedPlacesNearLocation(location, searchTerm: textField.text)
        return true
    }
}

extension CreatePlaceViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let vc = LocationSearchViewController()
        vc.searchAction = { [weak self] (name, coordinate) in
            self?.searchView.locationSearch.text = name
            self?.searchLocationCoord = coordinate
            self?.searchView.textSearch.becomeFirstResponder()
        }
        vc.searchTerm = searchView.locationSearch.text
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
  
}




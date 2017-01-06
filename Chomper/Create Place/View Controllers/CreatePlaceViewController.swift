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
    
    internal var searchLocationCoord: CLLocation?

    private var loadingView: UIView!
    private var loadingLabel: UILabel!
    private var searchTerm: String?
    private var tableVC: UITableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //
        // Set up tableViewController
        
        tableVC = UITableViewController()
        tableVC.tableView.dataSource = self
        tableVC.tableView.delegate = self
        tableVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableVC.view)
        tableVC.tableView.keyboardDismissMode = .onDrag
        tableVC.tableView.tableFooterView = UIView()
        tableVC.refreshControl = UIRefreshControl()
        tableVC.refreshControl?.tintColor = UIColor.darkOrange()
        tableVC.refreshControl?.isEnabled = true
        tableVC.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        tableVC.tableView.separatorStyle = .none
        tableVC.tableView.registerNib(PlaceTableViewCell.self)
        
        //
        // Set up search view
        
        searchView = CreatePlaceSearchView()
        searchView.cancelAction = { [weak self] in
            self?.searchView.cancelSearch()
            self?.searchLocationCoord = nil
        }
        searchView.searchAction = { [weak self] in
            guard let location = self?.searchLocationCoord ?? self?.locationManager.location else { return }
            self?.getRecommendedPlacesNearLocation(location: location, searchTerm: self?.searchView.textSearch.text)
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
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[searchView][tableVC]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[searchView][loadingView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableVC]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[searchView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[loadingView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        // 
        // Call webService for recommended places near current location

        guard let location = locationManager.location else { return }
        getRecommendedPlacesNearLocation(location: location, searchTerm: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if searchView.layer.shadowPath == nil {
            searchView.setShadow()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nil, bundle: nil)
        checkLocationPermission()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    internal func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, showLoading: Bool = true) {
        showLoadingView(show: showLoading)
        let _ = webService.getRecommendedPlacesNearLocation(location, searchTerm: searchTerm) { [weak self] (places, response, error) in
            if error == nil, let places = places {
                self?.viewModel = CreatePlaceViewModel(results: places)
                DispatchQueue.main.async (execute: { () -> Void in
                    self?.tableVC.tableView.reloadData()
                    self?.showLoadingView(show: false)
                    self?.tableVC.refreshControl?.endRefreshing()
                })
                
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    self?.showLoadingView(show: false)
                    self?.viewModel = nil
                    self?.tableVC.refreshControl?.endRefreshing()
                })

                // TODO: display no results placeholder view
            }
        }

    }
    
    func handleRefresh() {
        guard let location = searchLocationCoord ?? locationManager.location else { return }
        getRecommendedPlacesNearLocation(location: location, searchTerm: searchView.textSearch.text, showLoading: false)
    }
    
    // MARK: - Helpers
    
    func checkLocationPermission() {
        let CM = DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperLocationManagerProtocol.self)")
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            CM.locationManager.requestWhenInUseAuthorization()
            return
        } else if authStatus == .denied || authStatus == .restricted {
            // TODO: Handle this
            let alert = UIAlertController(title: NSLocalizedString("Location Access Disabled", comment: "Location access disabled"), message: NSLocalizedString("In order to find nearby places, Chomper needs access to your location while using the app.", comment: "location services disabled"), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action) in
                //
            })
            
            alert.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: NSLocalizedString("Open Settings", comment: "Open Settings"), style: .default, handler: { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            })
            
            alert.addAction(confirmAction)
        }
    }
    
    // MARK: - Helpers
    
    func showLoadingView(show: Bool = false) {
        if show {
            loadingView.isHidden = false
            loadingLabel.alpha = 0
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: { [weak self] in
                self?.loadingLabel.alpha = 1
                }, completion: nil)
            view.bringSubview(toFront: loadingView)
        } else {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.loadingView.isHidden = true
            })
        }
    }
    
    func createLoadingView() {
        loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.backgroundColor = UIColor.softWhite()
        loadingView.isHidden = true
        
        loadingLabel = UILabel()
        loadingView.addSubview(loadingLabel)
        loadingLabel.text = NSLocalizedString("Loading", comment: "Loading")
        loadingLabel.textColor = UIColor.darkOrange()
        loadingLabel.font = UIFont.chomperFontForTextStyle("h4")
       
        NSLayoutConstraint.useAndActivateConstraints([
            loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        ])
    }
    
    func quickSave(indexPath: NSIndexPath) {
        guard let place = viewModel?.results[indexPath.row] else { fatalError("Error selected object is invalid") }
        self.mainContext.performChanges {
            var image: Image? = nil
            let listPlace = ListPlace.insertIntoContext(self.mainContext, address: place.address, city: place.city, downloadImageUrl: place.imageUrl, listName: defaultSavedList, location: place.location, phone: place.phone, placeId: place.venueId, placeName: place.name, price: place.priceValue as NSNumber?, notes: place.userNotes, rating: place.ratingValue as NSNumber?, state: place.state)
    
            if let cached = (self.imageCache as? NSCache<AnyObject, AnyObject>)?.object(forKey: place.imageUrl as AnyObject) as? UIImage, let imageData = UIImagePNGRepresentation(cached) {
                image = Image.insertIntoContext(self.mainContext, createdAt: NSDate() as Date, imageData: imageData, thumbData: nil)
            }
            
            listPlace.listImageId = image?.id
        }
        tableVC.tableView.setEditing(false, animated: true)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell, let object = viewModel?.results[indexPath.row] else {fatalError("Error config PlaceTableViewCell")}
        cell.configureCell(withObject: object, imageCache: imageCache)
        if let image = (imageCache as? NSCache<AnyObject, AnyObject>)?.object(forKey: object.venueId as AnyObject) as? UIImage {
            cell.placeImageView.image = image
        } else {
            if let imageUrl = object.imageUrl, let url = NSURL(string: imageUrl) {
                URLSession.shared.dataTask(with: url as URL) { [weak self] (data, response, error) in
                    if error == nil, let data = data,
                        let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            (self?.imageCache as! NSCache).setObject(image, forKey: object.venueId as AnyObject)
                            if cell.imageUrl == object.imageUrl {
                                UIView.animate(withDuration: 0.2, animations: {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        guard let object = viewModel?.results[indexPath.row] else { fatalError("Error selected object is invalid") }
        let vm = PlaceDetailsViewModel(place: object, webService: webService)
        let vc = PlaceDetailsViewController(viewModel: vm)
        let nc = BaseNavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        quickSave(indexPath: indexPath as NSIndexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .normal, title: "Favorite") { [unowned self] (_, indexPath) in
            self.quickSave(indexPath: indexPath as NSIndexPath)
        }
        save.backgroundColor = UIColor.softOrange()
        return [save]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension CreatePlaceViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchView.enableSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let location = searchLocationCoord ?? locationManager.location else { return false }
        getRecommendedPlacesNearLocation(location: location, searchTerm: textField.text)
        return true
    }
}

extension CreatePlaceViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = LocationSearchViewController()
        vc.searchAction = { [weak self] (name, coordinate) in
            self?.searchView.locationSearch.text = name
            self?.searchLocationCoord = coordinate
            self?.searchView.textSearch.becomeFirstResponder()
        }
        vc.searchTerm = searchView.locationSearch.text
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
}

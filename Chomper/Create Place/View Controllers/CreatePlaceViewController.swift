//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import GoogleMaps
import Models
import RxSwift
import WebServices

class CreatePlaceViewController: BaseViewController {
    internal let locationManager = CLLocationManager()
    internal var viewModel: CreatePlaceViewModel
    internal var searchView: CreatePlaceSearchView!
    internal var searchLocationCoord: CLLocation? = nil

    var searchTerm = Variable<String>("")
    var location = Variable<CLLocation?>(nil)

    private let disposeBag = DisposeBag()
    private let loadingView = UIView()
    private let loadingLabel = UILabel()
    private let tableVC = UITableViewController()

    required init(viewModel: CreatePlaceViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.softWhite()
        
        //
        // Set up tableViewController
        
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
        
        searchView.cancelAction = { [weak self] in
            self?.searchView.cancelSearch()
            self?.searchLocationCoord = nil
        }
        searchView.searchAction = { [weak self] in
            guard let location = self?.searchLocationCoord ?? self?.locationManager.location else { return }
            self?.viewModel.fetchPlaces()
        }
        
        searchView.textField.delegate = self
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

        setupBindings()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if searchView.layer.shadowPath == nil {
            searchView.setShadow()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        viewModel
            .searchResults
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableVC.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)

        searchView
            .textUpdated
            .bindTo(viewModel.searchTerm)
            .addDisposableTo(disposeBag)
    }

    /*internal func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, showLoading: Bool = true) {
        showLoadingView(show: showLoading)
        let _ = webService.getRecommendedPlacesNearLocation(location: location, searchTerm: searchTerm) { [weak self] (places, error) in
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
                    self?.tableVC.refreshControl?.endRefreshing()
                })

                // TODO: display no results placeholder view
            }
        }
    }*/
    
    func handleRefresh() {
       viewModel.fetchPlaces()
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
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.backgroundColor = UIColor.softWhite()
        loadingView.isHidden = true
        
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
        let place = viewModel.searchResults.value[indexPath.row]
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
}

extension CreatePlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        let object = viewModel.searchResults.value[indexPath.row]
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
}

extension CreatePlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell else { fatalErrorInDebug(message: "Error config PlaceTableViewCell"); return UITableViewCell() }

        let object = viewModel.searchResults.value[indexPath.row]
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
}

extension CreatePlaceViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchView.enableSearch()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let location = searchLocationCoord ?? locationManager.location else { return false }
        viewModel.fetchPlaces()
        return true
    }
}

extension CreatePlaceViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = LocationSearchViewController()
        vc.searchAction = { [weak self] (name, coordinate) in
            self?.searchView.locationSearch.text = name
            self?.searchLocationCoord = coordinate
            self?.searchView.textField.becomeFirstResponder()
        }
        vc.searchTerm = searchView.locationSearch.text
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
}

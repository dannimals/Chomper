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
    internal var location = Variable<CLLocation?>(nil)
    internal var searchView = LocationSearchView()
    internal var searchTerm = Variable<String>("")
    internal var viewModel: CreatePlaceViewModel
    internal let statusView = SearchStatusView()
    private let tableVC = UITableViewController()

    required init(viewModel: CreatePlaceViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.softWhite()
        
        tableVC.tableView.dataSource = self
        tableVC.tableView.delegate = self
        view.addSubview(tableVC.view)
        tableVC.tableView.keyboardDismissMode = .onDrag
        tableVC.tableView.tableFooterView = UIView()
        tableVC.refreshControl = UIRefreshControl()
        tableVC.refreshControl?.tintColor = UIColor.darkOrange()
        tableVC.refreshControl?.isEnabled = true
        tableVC.refreshControl?.addTarget(self, action: #selector(searchTapped), for: .valueChanged)
        tableVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        tableVC.tableView.separatorStyle = .none
        tableVC.tableView.registerNib(PlaceTableViewCell.self)
        view.addSubview(searchView)

        searchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
        }

        view.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }

        tableVC.tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }

        if viewModel.numberOfRows() == 0 {
            showStatusViewWithText(text: "Start Searching!")
        }

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
        searchView
            .textUpdated
            .bindTo(viewModel.searchTerm)
            .addDisposableTo(disposeBag)

        searchView
            .textFieldDidBeginEditing
            .subscribe(onNext: { [weak self] _ in
                self?.searchView.enableSearch()
            })
            .addDisposableTo(disposeBag)

        searchView
            .cancelTapped
            .subscribe(onNext: { [weak self] _ in
                self?.searchView.cancelSearch()
            })
            .addDisposableTo(disposeBag)

        searchView
            .searchTapped
            .subscribe(onNext: { [unowned self] _ in
                self.searchTapped()
            })
            .addDisposableTo(disposeBag)

        // TODO: REFACTOR this code
        // this vc should not know about blocks in LocationSearchVC
        searchView
            .searchBarBeginEditing
            .subscribe(onNext: { [weak self] _ in
                let viewController = LocationSearchViewController()
                viewController.searchAction = { [weak self] (name, coordinate) in
                    self?.searchTerm.value = name
                    self?.location.value = coordinate
                    self?.searchView.textField.becomeFirstResponder()
                }
                viewController.searchTerm = self?.searchTerm.value
                let navController = UINavigationController(rootViewController: viewController)
                self?.present(navController, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

    func searchTapped() {
        hideStatusView()
        ChomperLoadingHUD.show()

        viewModel
            .fetchSearchResults()
            .asObservable()
            .subscribe(onNext: { [weak self] results in
                guard let results = results else {
                    ChomperLoadingHUD.dismiss()
                    self?.showStatusViewWithText(text: NSLocalizedString("Oops! No results were found", comment: "message"))
                    return
                }

                self?.hideStatusView()
                self?.viewModel.searchResults.value = results
                self?.tableVC.tableView.reloadData()
                ChomperLoadingHUD.dismiss()
                self?.tableVC.refreshControl?.endRefreshing()
            })
            .addDisposableTo(disposeBag)
    }

    func hideStatusView() {
        view.sendSubview(toBack: statusView)
    }

    func showStatusViewWithText(text: String) {
        statusView.updateLabel(text: text)
        statusView.isHidden = false
        view.bringSubview(toFront: statusView)
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

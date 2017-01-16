//
//  ListDetailsViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import Models

//
// TODO: Refactor this class to be reused by ListsTableVC

class ListDetailsViewController: BaseViewController {
    fileprivate var list: List! /*{
        didSet {
            observer = ManagedObjectObserver(object: list) { [unowned self] type in
                guard type == .Delete else { return }
                self.mainContext.performChanges {
                    self.mainContext.deleteObject(self.list)
                }
                self.dismissVC()
            }
        }
    }*/
    fileprivate var observer: ManagedObjectObserver?
    fileprivate var tableView: UITableView!
    fileprivate var viewModel: [ListPlace]!
    
    required init(listId: NSManagedObjectID) {
        super.init(nibName: nil, bundle: nil)
        list = mainContext.object(with: listId) as? List
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewModel = list.listPlaces?.sorted { $0.placeName < $1.placeName } ?? []
                
        // 
        // Configure view
        
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "close"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .plain, target: self, action: #selector(handleEdit))
    
        //
        // Configure table view
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(PlaceTableViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let views: [String: AnyObject] = [
            "topLayout": topLayoutGuide,
            "tableView": tableView
        ]
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[topLayout][tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
    }

    // MARK - Helpers
    
    func handleEdit() {
        //
        // Check to make sure list is deletable ie. not the default saved list
        if list.name != defaultSavedList {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let editAction = UIAlertAction(title: NSLocalizedString("Edit list", comment: "edit"), style: .default) { [unowned self] action in
                if action.isEnabled {
                    self.tableView.setEditing(true, animated: true)
                }
            }
            alertController.addAction(editAction)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete List", comment: "delete"), style: .destructive) { [unowned self] (action) in
                if action.isEnabled {
                    self.alertWithCancelButton(
                        NSLocalizedString("Cancel", comment: "cancel"),
                        confirmButton: NSLocalizedString("Confirm", comment: "confirm"),
                        title: NSLocalizedString("Are you sure?", comment: "check"),
                        message: NSLocalizedString("Deleting list will also delete its associated places.", comment: "message"),
                        destructiveStyle: true, confirmBold: true, style: .alert) { bool in
                            if bool {
                                self.mainContext.performChanges {
                                    if let listPlaces = self.list?.listPlaces {
                                        for listPlace in listPlaces {
                                            self.mainContext.delete(listPlace)
                                        }
                                    }
                                    self.mainContext.delete(self.list)
                                }
                                self.dismissVC()
                            }
                    }
                }
            }
            alertController.addAction(deleteAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            beginEditing()
        }
    }
    
    
    // MARK: - Handlers
    
    func deleteItemAtIndexPath(_ indexPath: IndexPath) {
        let place = viewModel[indexPath.row]
        viewModel.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        mainContext.performChanges {
            self.mainContext.delete(place)
        }
    }
    
    func markItemAtIndexPath(_ indexPath: IndexPath) {
        let listPlace = viewModel[indexPath.row]
        let visited = listPlace.place?.visited == NSNumber(value: 0) ? NSNumber(value: 1) : NSNumber(value: 0)
        mainContext.performChanges {
            listPlace.place?.visited = visited
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func beginEditing() {
        tableView.setEditing(true, animated: true)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
        navigationItem.setRightBarButton(cancel, animated: true)

    }
    
    func cancelEditing() {
        tableView.setEditing(false, animated: true)
        let edit = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .plain, target: self, action: #selector(handleEdit))
        navigationItem.setRightBarButton(edit, animated: true)
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension ListDetailsViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: - UITableViewDelegate delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell else { fatalError("cell not dequeued") }
        return cell
    }
    
    // MARK: - UITableViewDataSource delegate methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { fatalError("cell not found") }
        let listPlace = viewModel[indexPath.row]
        var location: CLLocation? = nil
        if let lat = listPlace.place?.latitude, let long = listPlace.place?.longitude {
            location = CLLocation(latitude: Double(lat), longitude: Double(long))
        }
        cell.configurePlaceCell(listPlace.place!.name, address: listPlace.place?.streetName, rating: listPlace.rating, price: listPlace.price, location: location, visited: listPlace.place?.visited ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = viewModel[indexPath.row]
        let vm = PlaceDetailsViewModel(place: place, webService: webService)
        let vc = PlaceDetailsViewController(viewModel: vm)
        let nc = BaseNavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            deleteItemAtIndexPath(indexPath)
        } else {
            markItemAtIndexPath(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "delete")) { [unowned self] (_, indexPath) in
            self.deleteItemAtIndexPath(indexPath)
        }
        delete.backgroundColor = UIColor.red
        
        let listPlace = viewModel[indexPath.row]
        let visitedTitle = listPlace.place?.visited?.boolValue ?? false ? NSLocalizedString("Not Visited", comment: "not visited") : NSLocalizedString("Visited", comment: "visited")
        let visited = UITableViewRowAction(style: .normal, title: visitedTitle) { [unowned self] (_, indexPath) in
            self.markItemAtIndexPath(indexPath)
        }
        visited.backgroundColor = UIColor.orange
        
        return [visited, delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
}

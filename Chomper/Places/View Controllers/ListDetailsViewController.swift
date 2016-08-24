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
    private var list: List! /*{
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
    private var observer: ManagedObjectObserver?
    private var tableView: UITableView!
    private var viewModel: [Place]!
    
    required init(listId: NSManagedObjectID) {
        super.init(nibName: nil, bundle: nil)
        list = mainContext.objectWithID(listId) as? List
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewModel = list.places?.sort { $0.name < $1.name } ?? []
                
        // 
        // Configure view
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "close"), style: .Plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .Plain, target: self, action: #selector(handleEdit))
    
        //
        // Configure table view
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        
        let views: [String: AnyObject] = [
            "topLayout": topLayoutGuide,
            "tableView": tableView
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[topLayout][tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[tableView]|",
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
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let editAction = UIAlertAction(title: NSLocalizedString("Edit list", comment: "edit"), style: .Default) { [unowned self] action in
                if action.enabled {
                    self.tableView.setEditing(true, animated: true)
                }
            }
            alertController.addAction(editAction)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete List", comment: "delete"), style: .Destructive) { [unowned self] (action) in
                if action.enabled {
                    self.alertWithCancelButton(
                        NSLocalizedString("Cancel", comment: "cancel"),
                        confirmButton: NSLocalizedString("Confirm", comment: "confirm"),
                        title: NSLocalizedString("Are you sure?", comment: "check"),
                        message: NSLocalizedString("Deleting list will also delete its associated places.", comment: "message"),
                        destructiveStyle: true, confirmBold: true, style: .Alert) { bool in
                            if bool {
                                self.mainContext.performChanges {
                                    self.mainContext.deleteObject(self.list)
                                }
                                self.dismissVC()
                            }
                    }
                }
            }
            alertController.addAction(deleteAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            beginEditing()
        }

    }
    
    
    // MARK: - Handlers
    
    func deleteItemAtIndexPath(indexPath: NSIndexPath) {
        let place = viewModel[indexPath.row]
        viewModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        mainContext.performChanges {
            self.mainContext.deleteObject(place)
        }
    }
    
    func markItemAtIndexPath(indexPath: NSIndexPath) {
        let place = viewModel[indexPath.row]
        let visited = place.visited == NSNumber(int: 0) ? NSNumber(int: 1) : NSNumber(int: 0)
        mainContext.performChanges {
            place.visited = visited
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func beginEditing() {
        tableView.setEditing(true, animated: true)
        let cancel = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelEditing))
        navigationItem.setRightBarButtonItem(cancel, animated: true)

    }
    
    func cancelEditing() {
        tableView.setEditing(false, animated: true)
        let edit = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .Plain, target: self, action: #selector(handleEdit))
        navigationItem.setRightBarButtonItem(edit, animated: true)
    }
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ListDetailsViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: - UITableViewDelegate delegate methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as? PlaceTableViewCell else { fatalError("cell not dequeued") }
        return cell
    }
    
    // MARK: - UITableViewDataSource delegate methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { fatalError("cell not found") }
        let place = viewModel[indexPath.row]
        var location: CLLocation? = nil
        if let lat = place.latitude, long = place.longitude {
            location = CLLocation(latitude: Double(lat), longitude: Double(long))
        }
        cell.configurePlaceCell(place.name, address: place.streetName, rating: place.rating, price: place.price, location: location, visited: place.visited ?? 0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let object = viewModel[indexPath.row]
        let vc = PlaceDetailsViewController(place: object.remoteId)
        let nc = BaseNavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            deleteItemAtIndexPath(indexPath)
        } else {
            markItemAtIndexPath(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: NSLocalizedString("Delete", comment: "delete")) { [unowned self] (_, indexPath) in
            self.deleteItemAtIndexPath(indexPath)
        }
        delete.backgroundColor = UIColor.redColor()
        
        let place = viewModel[indexPath.row]
        let visitedTitle = place.visited?.boolValue ?? false ? NSLocalizedString("Not Visited", comment: "not visited") : NSLocalizedString("Visited", comment: "visited")
        let visited = UITableViewRowAction(style: .Normal, title: visitedTitle) { [unowned self] (_, indexPath) in
            self.markItemAtIndexPath(indexPath)
        }
        visited.backgroundColor = UIColor.orangeColor()
        
        return [visited, delete]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
}







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

class ListDetailsViewController: BaseViewController {
    private var list: PlaceList! /*{
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
    
    required init(placeListId: NSManagedObjectID) {
        super.init(nibName: nil, bundle: nil)
        list = mainContext.objectWithID(placeListId) as? PlaceList
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        //
        // Check to make sure list is deletable ie. not the default saved list
        if list.sequenceNum != 1 {
            let deleteAction = UIAlertAction(title: "Delete List", style: .Destructive) { [unowned self] (action) in
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
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ListDetailsViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as? PlaceTableViewCell else { fatalError("cell not dequeued") }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { fatalError("cell not found") }
        let place = viewModel[indexPath.row]
        var location: CLLocation? = nil
        if let lat = place.latitude, long = place.longitude {
            location = CLLocation(latitude: Double(lat), longitude: Double(long))
        }
        cell.configurePlaceCell(place.name, address: place.streetName, rating: place.rating, price: place.price, location: location)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
}







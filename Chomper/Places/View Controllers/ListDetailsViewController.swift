//
//  ListDetailsViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
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
    
    required init(placeList: PlaceList) {
        super.init(nibName: nil, bundle: nil)
        mainContext.performBlock {
            self.list = self.mainContext.objectWithID(placeList.objectID) as? PlaceList
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("1: \(list)")
        print("2: \(list.places)")
        print("3: \(list.places?.count)")
        print("4: \(list.places)")
        
        
        // 
        // Configure view
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "close"), style: .Plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .Plain, target: self, action: #selector(handleEdit))
    
        //
        // Configure table view
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        
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
        
        if list.name != NSLocalizedString("Saved", comment: "saved") {
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

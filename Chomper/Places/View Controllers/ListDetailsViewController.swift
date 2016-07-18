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
    private var listObject: PlaceList! /*{
        didSet {
            observer = ManagedObjectObserver(object: listObject) { [unowned self] type in
                guard type == .Delete else { return }
                self.mainContext.performChanges {
                    self.mainContext.deleteObject(self.listObject)
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }*/
    private var observer: ManagedObjectObserver?
    private var tableView: UITableView!
    
    required init(placeList: PlaceList) {
        super.init(nibName: nil, bundle: nil)
        mainContext.performBlock {
            self.listObject = self.mainContext.objectWithID(placeList.objectID) as? PlaceList
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let deleteAction = UIAlertAction(title: "Delete List", style: .Destructive) { [unowned self] (action) in
            if action.enabled {
                self.mainContext.performChanges {
                    self.mainContext.deleteObject(self.listObject)
                }
                self.dismissVC()
            }
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//
//  PlaceDetailsViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Foundation

class PlaceDetailsViewController: BaseViewController {
    
    private var venue: SearchResult!
    
    required init(venue: SearchResult) {
        self.venue = venue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up view
        
        title = venue.name
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("+", comment: "Add"), style: .Plain, target: self, action: #selector(add(_:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")], forState: .Normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"), style: .Plain, target: self, action: #selector(dismissVC(_:)))
        //getPlaceDetails()
    }
    
    
    // MARK: - Handlers
    
    func getPlaceDetails() {
        webService.getDetailsForPlace(venue.venueId) { (json, response, error) in
            if error == nil {
                print(json)
            } else {
                // TODO: Handle error
            }
        }
    }
    
    func add(sender: UIBarButtonItem) {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//            let deleteAction = UIAlertAction(title: "Delete List", style: .Destructive) { [unowned self] (action) in
//                if action.enabled {
//                    self.alertWithCancelButton(
//                        NSLocalizedString("Cancel", comment: "cancel"),
//                        confirmButton: NSLocalizedString("Confirm", comment: "confirm"),
//                        title: NSLocalizedString("Are you sure?", comment: "check"),
//                        message: NSLocalizedString("Deleting list will also delete its associated places.", comment: "message"),
//                        destructiveStyle: true, confirmBold: true, style: .Alert) { bool in
//                            if bool {
//                                self.mainContext.performChanges {
//                                    self.mainContext.deleteObject(self.list)
//                                }
//                                self.dismissVC()
//                            }
//                    }
//                }
//            }
//            alertController.addAction(deleteAction)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
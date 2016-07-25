//
//  PlaceDetailsViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class PlaceDetailsViewController: BaseViewController {
    
    private var place: SearchResult!
    
    init(place: SearchResult) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up view
        
        title = place.name
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")], forState: .Normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"), style: .Plain, target: self, action: #selector(dismissVC(_:)))
        //getPlaceDetails()
    }
    
    
    // MARK: - Handlers
    
    func getPlaceDetails() {
        webService.getDetailsForPlace(place.venueId) { (json, response, error) in
            if error == nil {
                print(json)
            } else {
                // TODO: Handle error
            }
        }
    }
    
    func add(sender: UIBarButtonItem) {
        let vc = ActionListViewController()
        vc.modalTransitionStyle = .CrossDissolve
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: true, completion: nil)
        
        
        
        /*let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let quickSave = UIAlertAction(title: NSLocalizedString("Save", comment: "quick save"), style: .Default) { [unowned self] (action) in
            if action.enabled {
                self.mainContext.performChanges {
                    Place.insertIntoContext(self.mainContext, city: nil, creatorId: nil, location: self.place.location, name: self.place.name, notes: nil, price: self.place.price, rating: self.place.rating, streetName: self.place.address, state: nil, updatedAt: NSDate(), visited: false, zipcode: nil, placeListName: defaultSavedList)
                }
                self.dismissVC(UIBarButtonItem())
            }
          
        }
        alertController.addAction(quickSave)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)*/
    }
    
    func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
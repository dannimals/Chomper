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
        getPlaceDetails()
    }
    
    
    // MARK: - Handlers
    
    func getPlaceDetails() {
        webService.getDetailsForPlace(place.venueId) { (result, response, error) in
            if error == nil {
                print(result)
            } else {
                // TODO: Handle error
            }
        }
    }
    
    func add(sender: UIBarButtonItem) {
        let vc = ActionListViewController(place: place)
        vc.modalTransitionStyle = .CoverVertical
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
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
    private var detailsView: PlaceDetailsView!
    
    // TODO: Rethink the logic of having to pass in an actual place rather than a placeId
    // and then calling webservice for details
    required init(place: SearchResult) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let scrollView = UIScrollView()
        detailsView = UIView.loadNibWithName(PlaceDetailsView.self)
        scrollView.addSubview(detailsView)
        detailsView.sizeToFit()

        scrollView.contentSize = detailsView.bounds.size
        view = scrollView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set the frame of the detailsView here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up view controller
        
        title = place.name
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")], forState: .Normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"), style: .Plain, target: self, action: #selector(dismissVC(_:)))
        
        //
        // Get Place Details
        
        getPlaceDetails()

        // Set details
        
        setPlaceDetails()
        
    }
    
    
    // MARK: - Handlers
    
    func getPlaceDetails() {
        webService.getDetailsForPlace(place.venueId) { (result, response, error) in
            if error == nil {
            } else {
                // TODO: Handle error
            }
        }
    }
    
    func setPlaceDetails() {
        detailsView.address = place.address
        detailsView.price = place.price
        detailsView.phone = place.phone
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
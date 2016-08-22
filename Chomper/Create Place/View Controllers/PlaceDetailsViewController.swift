//
//  PlaceDetailsViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models
import MapKit

class PlaceDetailsViewController: BaseViewController, MKMapViewDelegate {
    static let imageCache: NSCache = {
        let cache = NSCache()
        cache.name = "ChomperImageCache"
        cache.countLimit = 20
        cache.totalCostLimit = 10 * 1024 * 1024
        return cache
    }()
    
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
        
        scrollView.contentSize = CGSize(width: detailsView.bounds.width, height: UIScreen.mainScreen().bounds.height)
        view = scrollView
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
        // Download, if needed, and set the place image
        
        if let image = PlaceDetailsViewController.imageCache[place.venueId] as? UIImage {
            detailsView.imageView.image = image
        } else {
            getPlaceDetails()
        }

        // Set details
        
        setPlaceDetails()
        
    }
    
    
    // MARK: - Handlers
    
    func getPlaceDetails() {
        webService.getDetailsForPlace(place.venueId) { [weak self] (result, response, error) in
            if error == nil {
                if let url = NSURL(string: result?.photoUrl ?? "") {
                    self?.downloadImageForUrl(url)
                }
            } else {
                // TODO: Handle error
            }
        }
    }
    
    func downloadImageForUrl(url: NSURL) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { [weak self] (data, response, error) in
            if error == nil, let data = data, let id = self?.place.venueId {
                let image = UIImage(data: data)
                PlaceDetailsViewController.imageCache[id] = image

                dispatch_async(dispatch_get_main_queue()) {
                    self?.detailsView.imageView.alpha = 0
                    self?.detailsView.imageView.image = image

                    UIView.animateWithDuration(0.4) { [weak self] in
                        self?.detailsView.imageView.alpha = 1
                    }
                }
            }
        }.resume()
    }
    
    func setPlaceDetails() {
        detailsView.mapView.delegate = self
        
        let attrText = NSMutableAttributedString()
        if let address = place.address {
            attrText.appendAttributedString(NSAttributedString(string: address))
            if let city = place.city, state = place.state {
                attrText.appendAttributedString(NSAttributedString(string: "\n\(city), \(state)"))
            }
        } else {
            if let city = place.city, state = place.state {
                attrText.appendAttributedString(NSAttributedString(string: "\(city), \(state)"))
            }
        }

        detailsView.formattedAddress = attrText
        detailsView.location = place.location
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

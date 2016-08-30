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
    
    // MARK: - Properties
    
    private var placeModel: PlaceDetailsObjectProtocol!
    private var detailsView: PlaceDetailsView!
    private let placeHolderText = NSLocalizedString("Add a note", comment: "add a note")
    private var scrollView: UIScrollView!
    
    // TODO: Rethink the logic of having to pass in an actual place rather than a placeId
    // and then calling webservice for details
    required init(place: PlaceDetailsObjectProtocol) {
        super.init(nibName: nil, bundle: nil)
        if place.type == "\(ListPlace.self)" {
            self.placeModel = ListPlace.findOrCreateListPlace(place.venueId, listName: place.name, inContext: self.mainContext)
        } else {
            self.placeModel = place
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .OnDrag
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
        
        title = placeModel.name
        view.backgroundColor = UIColor.whiteColor()
        if placeModel.type == "\(SearchResult.self)"  {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")], forState: .Normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action:  #selector(edit(_:)))
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"), style: .Plain, target: self, action: #selector(dismissVC(_:)))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //
        // Download, if needed, and set the place image
        
        if let image = imageCache[placeModel.venueId] as? UIImage {
            detailsView.imageView.image = image
        } else {
            getPlaceDetails(placeModel.venueId)
        }
        
        //
        // Set details
        
        setPlaceDetails()
    }
    
    
    // MARK: - Handlers
    
    func getPlaceDetails(id: String) {
        webService.getDetailsForPlace(id) { [weak self] (result, response, error) in
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
            if error == nil, let data = data, let id = self?.placeModel.venueId {
                let image = UIImage(data: data)
                self?.imageCache[id] = image

                dispatch_async(dispatch_get_main_queue()) {
                    self?.detailsView.imageView.alpha = 0
                    self?.detailsView.imageView.image = image

                    UIView.animateWithDuration(0.4) {
                        self?.detailsView.imageView.alpha = 1
                    }
                }
            }
        }.resume()
    }
    
    func setPlaceDetails() {
        detailsView.mapView.delegate = self
        detailsView.mapViewAction = { [unowned self] in
            let mapVC = MapDetailsViewController(placeLocation: self.placeModel.location)
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        detailsView.phoneAction = { [unowned self] in
            let formattedPhone = self.placeModel.phone?.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
            if let formattedPhone = formattedPhone, phoneUrl = NSURL(string: "tel://\(formattedPhone)") {
                if UIApplication.sharedApplication().canOpenURL(phoneUrl) {
                    UIApplication.sharedApplication().openURL(phoneUrl)
                }
            }
        }
        
        detailsView.notesView.delegate = self
        
        let attrText = NSMutableAttributedString()
        if let address = placeModel.address {
            attrText.appendAttributedString(NSAttributedString(string: address))
            if let city = placeModel.city, state = placeModel.state {
                attrText.appendAttributedString(NSAttributedString(string: "\n\(city), \(state)"))
            }
        } else {
            if let city = placeModel.city, state = placeModel.state  {
                attrText.appendAttributedString(NSAttributedString(string: "\(city), \(state)"))
            }
        }

        detailsView.formattedAddress = attrText
        detailsView.location = placeModel.location
        detailsView.price = placeModel.priceValue
        detailsView.phone = placeModel.phone
        detailsView.notesView.text = placeHolderText
        detailsView.rating = placeModel.ratingValue
    }
    
    func keyboardWillAppear(notif: NSNotification) {
        if let userInfo = notif.userInfo, keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(0.4) {
//                self.detailsView.detailsViewBottomConstraint.constant = keyboardFrame.size.height
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.detailsView.frame.maxY - keyboardFrame.minY + self.detailsView.notesView.bounds.height )
            }
        }
    }
    
    func keyboardWillDisappear(notif: NSNotification) {
        detailsView.notesView.resignFirstResponder()
        if detailsView.notesView.text.isEmpty {
            detailsView.notesView.text = placeHolderText
        }
    }
    
    func add(sender: UIBarButtonItem) {
        let vc = ActionListViewController(place: placeModel)
        vc.modalTransitionStyle = .CoverVertical
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func edit(sender: UIBarButtonItem) {
        // TODO
    }
    
    func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        detailsView.notesView.resignFirstResponder()
    }
}

extension PlaceDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.4) {
            if textView.text == self.placeHolderText {
                textView.text = ""
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.isEmpty {
            UIView.animateWithDuration(0.4) {
                textView.text = self.placeHolderText
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeHolderText {
            UIView.animateWithDuration(0.4) {
                textView.text.removeAll()
            }
        }
        return true
    }

}





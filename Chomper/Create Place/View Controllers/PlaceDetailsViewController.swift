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

class PlaceDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var viewModel: PlaceDetailsViewModel!
    private var detailsView: PlaceDetailsView!
    private var scrollView: UIScrollView!
    
    required init(viewModel: PlaceDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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
        
        title = viewModel.name
        view.backgroundColor = UIColor.whiteColor()
        if viewModel.type == "\(SearchResult.self)"  {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")], forState: .Normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action:  #selector(edit(_:)))
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"), style: .Plain, target: self, action: #selector(dismissVC(_:)))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        detailsView.imageCollectionView.registerClass(ImageCollectionCell.self, forCellWithReuseIdentifier:String(ImageCollectionCell))
        detailsView.imageCollectionView.delegate = self
        detailsView.imageCollectionView.dataSource = self

        viewModel.getPlaceImages {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.detailsView.imageCollectionView.reloadData()
            }
        }
        
        //
        // Set details
        detailsView.mapView.delegate = self
        detailsView.mapViewAction = { [unowned self] in
            let mapVC = MapDetailsViewController(placeLocation: self.viewModel.location)
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        detailsView.notesView.delegate = self
        detailsView.configureWithViewModel(viewModel)
    }
    
    
    // MARK: - Handlers
    
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
            detailsView.notesView.text = detailsView.placeHolderText
        }
    }
    
    func add(sender: UIBarButtonItem) {
//        placeModel.userNotes = detailsView.notesView.text
//        let vc = ActionListViewController(place: placeModel)
//        vc.modalTransitionStyle = .CoverVertical
//        vc.modalPresentationStyle = .OverCurrentContext
//        presentViewController(vc, animated: true, completion: nil)
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

extension PlaceDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ImageCollectionCell), forIndexPath: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }
        guard let photo = viewModel.photos?[indexPath.row], url = NSURL(string: photo.url)  else { return imageCell }
        imageCell.photoUrl = photo.url
        
        if let image = imageCache[photo.url] as? UIImage {
            imageCell.imageView.image = image
        } else {
            viewModel.getImageWithUrl(url) { [weak self] (image) in
                dispatch_async(dispatch_get_main_queue()) {
                    imageCell.configureCellWithImage(image, withImageUrl: url, imageCache: self?.imageCache)
                }
            }
        }
        return imageCell
    }
}

extension PlaceDetailsViewController: MKMapViewDelegate {}

extension PlaceDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.4) {
            if textView.text == self.detailsView.placeHolderText {
                textView.text = ""
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.isEmpty {
            UIView.animateWithDuration(0.4) {
                textView.text = self.detailsView.placeHolderText
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView.text == detailsView.placeHolderText {
            UIView.animateWithDuration(0.4) {
                textView.text.removeAll()
            }
        }
        return true
    }

}





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
import WebServices

class PlaceDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    
    fileprivate var detailsView: PlaceDetailsView!
    fileprivate var scrollView: UIScrollView!
    fileprivate var viewModel: PlaceDetailsViewModel!

    required init(viewModel: PlaceDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        detailsView = UIView.loadNibWithName(PlaceDetailsView.self)
        scrollView.addSubview(detailsView)
        detailsView.sizeToFit()
        
        scrollView.contentSize = CGSize(width: detailsView.bounds.width, height: UIScreen.main.bounds.height)
        view = scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up view controller
        
        title = viewModel.name
        view.backgroundColor = UIColor.white
        if viewModel.type == "\(SearchPlace.self)"  {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")], for: UIControlState())
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:  #selector(edit(_:)))
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"), style: .plain, target: self, action: #selector(dismissVC(_:)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        detailsView.imageCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier:String(describing: ImageCollectionCell.self))
        detailsView.imageCollectionView.delegate = self
        detailsView.imageCollectionView.dataSource = self

        viewModel.getPlaceImages {
            DispatchQueue.main.async { [weak self] in
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
    
    func keyboardWillAppear(_ notif: Notification) {
        if let userInfo = notif.userInfo, let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.4, animations: {
//                self.detailsView.detailsViewBottomConstraint.constant = keyboardFrame.size.height
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.detailsView.frame.maxY - keyboardFrame.minY + self.detailsView.notesView.bounds.height )
            }) 
        }
    }
    
    func keyboardWillDisappear(_ notif: Notification) {
        detailsView.notesView.resignFirstResponder()
        if detailsView.notesView.text.isEmpty {
            detailsView.notesView.text = detailsView.placeHolderText
        }
    }
    
    func add(_ sender: UIBarButtonItem) {
        viewModel.userNotes = detailsView.notesView.text
        let actionViewModel = ActionListViewModel(place: viewModel.place, mainContext: mainContext)
        let vc = ActionListViewController(viewModel: actionViewModel)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func edit(_ sender: UIBarButtonItem) {
        // TODO
    }
    
    func dismissVC(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        detailsView.notesView.resignFirstResponder()
    }
}

extension PlaceDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionCell.self), for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }
        guard let photo = viewModel.photos?[indexPath.row], let url = URL(string: photo.url)  else { return imageCell }
        imageCell.photoUrl = photo.url
        
        if let image = (imageCache as? NSCache<AnyObject, AnyObject>)?.object(forKey: photo.url as AnyObject) as? UIImage {
            imageCell.imageView.image = image
        } else {
            viewModel.getImageWithUrl(url) { [weak self] (image) in
                DispatchQueue.main.async {
                    imageCell.configureCellWithImage(image, withImageUrl: url, imageCache: self?.imageCache)
                }
            }
        }
        return imageCell
    }
}

extension PlaceDetailsViewController: MKMapViewDelegate {}

extension PlaceDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4, animations: {
            if textView.text == self.detailsView.placeHolderText {
                textView.text = ""
            }
        }) 
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            UIView.animate(withDuration: 0.4, animations: {
                textView.text = self.detailsView.placeHolderText
            }) 
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == detailsView.placeHolderText {
            UIView.animate(withDuration: 0.4, animations: {
                textView.text.removeAll()
            }) 
        }
        return true
    }
}

//
//  CreatePlaceSearchView.swift
//  Chomper
//
//  Created by Danning Ge on 7/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Foundation

class CreatePlaceSearchView: UIView {
    
    var buttonContainerView: UIView!
    var containerView: UIStackView!
    var cancelButton: UIButton!
    var locationSearch: UISearchBar!
    var searchButton: UIButton!
    var textSearch: UITextField!
    
    var cancelAction: (() -> Void)?
    var searchAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        
        containerView = UIStackView()
        containerView.axis = .Vertical
        containerView.alignment = .Fill
        containerView.distribution = .Fill
        containerView.layoutMargins = UIEdgeInsetsMake(10, 15, 10, 15)
        containerView.layoutMarginsRelativeArrangement = true
        containerView.spacing = 8.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        containerView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        
        buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(buttonContainerView)
        buttonContainerView.heightAnchor.constraintEqualToConstant(30.0).active = true
        
        cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), forControlEvents: .TouchUpInside)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStye("p-small")
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), forState: .Normal)
        cancelButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.addSubview(cancelButton)
        cancelButton.leftAnchor.constraintEqualToAnchor(buttonContainerView.leftAnchor).active = true
        cancelButton.topAnchor.constraintEqualToAnchor(buttonContainerView.topAnchor).active = true
        
        searchButton = UIButton()
        searchButton.addTarget(self, action: #selector(searchAction(_:)), forControlEvents: .TouchUpInside)
        searchButton.titleLabel?.font = UIFont.chomperFontForTextStye("h4")
        searchButton.setTitle(NSLocalizedString("Search", comment: "Search"), forState: .Normal)
        searchButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.addSubview(searchButton)
        searchButton.rightAnchor.constraintEqualToAnchor(buttonContainerView.rightAnchor).active = true
        searchButton.topAnchor.constraintEqualToAnchor(buttonContainerView.topAnchor).active = true
        
        textSearch = UITextField()
        textSearch.font = UIFont.chomperFontForTextStye("p-small")
        textSearch.placeholder = NSLocalizedString("Search", comment: "Search")
        textSearch.backgroundColor = UIColor.whiteColor()
        textSearch.layer.cornerRadius = 5.0
        textSearch.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(textSearch)
        textSearch.heightAnchor.constraintEqualToConstant(25.0).active = true
        
        locationSearch = UISearchBar()
        locationSearch.layer.cornerRadius = 5.0
        locationSearch.clipsToBounds = true
        locationSearch.layer.borderWidth = 1.0
        locationSearch.layer.borderColor = UIColor.whiteColor().CGColor
        locationSearch.placeholder = NSLocalizedString("Current location", comment: "Current location")
        locationSearch.backgroundImage = UIImage.fromColor(UIColor.whiteColor())
        locationSearch.barTintColor = UIColor.whiteColor()
        locationSearch.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(locationSearch)
        locationSearch.heightAnchor.constraintEqualToConstant(25.0).active = true
        
        buttonContainerView.hidden = true
        locationSearch.hidden = true
    }
    
    // MARK: - Helpers
    
    func activateSearch() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .CurveEaseIn, animations: { [weak self] in
            self?.buttonContainerView.hidden = false
            self?.locationSearch.hidden = false
            self?.textSearch.becomeFirstResponder()
        }, completion: nil)
    }
    
    func cancelSearch() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .CurveEaseIn, animations: { [weak self] in
            self?.buttonContainerView.hidden = true
            self?.locationSearch.hidden = true
            self?.textSearch.resignFirstResponder()
            }, completion: { [weak self] bool in
                self?.locationSearch.text = nil
                self?.textSearch.text = nil
        })
      
    }
    
    @IBAction
    func cancelAction(sender: UIButton) {
        cancelAction?()
    }
    
    @IBAction
    func searchAction(sender: UIButton) {
        searchAction?()
    }
    
}
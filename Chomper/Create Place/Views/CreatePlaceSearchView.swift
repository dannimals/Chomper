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
    var view: UIView!
    
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
        view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        addSubview(view)
        
        containerView = UIStackView()
        containerView.axis = .Vertical
        containerView.alignment = .Fill
        containerView.distribution = .Fill
        containerView.layoutMargins = UIEdgeInsetsMake(8, 15, 8, 15)
        containerView.layoutMarginsRelativeArrangement = true
        containerView.spacing = 8.0
        view.addSubview(containerView)
        
        buttonContainerView = UIView()
        containerView.addArrangedSubview(buttonContainerView)
        let constraint = buttonContainerView.heightAnchor.constraintEqualToConstant(30.0)
        constraint.priority = UILayoutPriorityDefaultHigh
        
        cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), forControlEvents: .TouchUpInside)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("p-small")
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), forState: .Normal)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        buttonContainerView.addSubview(cancelButton)
        
        searchButton = UIButton()
        searchButton.addTarget(self, action: #selector(searchAction(_:)), forControlEvents: .TouchUpInside)
        searchButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        searchButton.setTitle(NSLocalizedString("Search", comment: "Search"), forState: .Normal)
        searchButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        buttonContainerView.addSubview(searchButton)

        
        textSearch = UITextField()
        textSearch.tintColor = UIColor.orangeColor()
        textSearch.clearButtonMode = .WhileEditing
        textSearch.returnKeyType = .Search
        textSearch.font = UIFont.chomperFontForTextStyle("p")
        textSearch.textColor = UIColor.darkGrayColor()
        textSearch.placeholder = NSLocalizedString("Search", comment: "Search")
        textSearch.backgroundColor = UIColor.whiteColor()
        textSearch.layer.cornerRadius = 5.0
        containerView.addArrangedSubview(textSearch)
        let paddingView = UIView(frame: CGRectMake(0, 0, 15.0, 30.0))
        textSearch.leftView = paddingView
        textSearch.leftViewMode = .Always
        
        locationSearch = UISearchBar()
        locationSearch.layer.cornerRadius = 5.0
        locationSearch.clipsToBounds = true
        locationSearch.layer.borderWidth = 1.0
        locationSearch.layer.borderColor = UIColor.whiteColor().CGColor
        locationSearch.placeholder = NSLocalizedString("Current location", comment: "Current location")
        locationSearch.backgroundImage = UIImage.fromColor(UIColor.whiteColor())
        locationSearch.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(locationSearch)
        let heightConstraint = locationSearch.heightAnchor.constraintEqualToConstant(30.0)
        heightConstraint.priority = UILayoutPriorityDefaultHigh
        
        buttonContainerView.hidden = true
        locationSearch.hidden = true
        
        NSLayoutConstraint.useAndActivateConstraints([
            view.topAnchor.constraintEqualToAnchor(topAnchor),
            view.leftAnchor.constraintEqualToAnchor(leftAnchor),
            view.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            view.rightAnchor.constraintEqualToAnchor(rightAnchor),
            constraint,
            containerView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20),
            containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            containerView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            cancelButton.leftAnchor.constraintEqualToAnchor(buttonContainerView.leftAnchor),
            cancelButton.topAnchor.constraintEqualToAnchor(buttonContainerView.topAnchor),
            searchButton.rightAnchor.constraintEqualToAnchor(buttonContainerView.rightAnchor),
            searchButton.topAnchor.constraintEqualToAnchor(buttonContainerView.topAnchor),
            textSearch.heightAnchor.constraintEqualToConstant(30.0),
            heightConstraint
        ])
    }
    
    // MARK: - Helpers
    
    func enableSearch() {
        UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .CurveEaseIn, animations: { [weak self] in
            self?.layer.shadowOpacity = 0
            self?.buttonContainerView.hidden = false
            self?.locationSearch.hidden = false
            self?.textSearch.becomeFirstResponder()
            }, completion: { [weak self] finished in
                self?.setShadow()
        })
    }
    
    func cancelSearch() {
        setShadow(UIColor.lightGrayColor().CGColor, opacity: 0.75, height: 3.5, shadowRect: CGRect(x: 0, y: 65.0, width: bounds.width, height: 3.5))
        UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .CurveEaseIn, animations: { [weak self] in
            self?.buttonContainerView.hidden = true
            self?.locationSearch.hidden = true
            self?.textSearch.resignFirstResponder()
            }, completion: { [weak self] finished in
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
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
        view.backgroundColor = UIColor.darkOrange()
        addSubview(view)
        
        containerView = UIStackView()
        containerView.axis = .vertical
        containerView.alignment = .fill
        containerView.distribution = .fill
        containerView.layoutMargins = UIEdgeInsetsMake(8, 15, 8, 15)
        containerView.isLayoutMarginsRelativeArrangement = true
        containerView.spacing = 8.0
        view.addSubview(containerView)
        
        buttonContainerView = UIView()
        containerView.addArrangedSubview(buttonContainerView)
        let constraint = buttonContainerView.heightAnchor.constraint(equalToConstant: 30.0)
        constraint.priority = UILayoutPriorityDefaultHigh
        
        cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("p-small")
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), for: UIControlState())
        cancelButton.setTitleColor(UIColor.softGrey(), for: .highlighted)
        buttonContainerView.addSubview(cancelButton)
        
        searchButton = UIButton()
        searchButton.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        searchButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        searchButton.setTitle(NSLocalizedString("Search", comment: "Search"), for: UIControlState())
        searchButton.setTitleColor(UIColor.softGrey(), for: .highlighted)
        buttonContainerView.addSubview(searchButton)

        
        textSearch = UITextField()
        textSearch.tintColor = UIColor.darkOrange()
        textSearch.clearButtonMode = .whileEditing
        textSearch.returnKeyType = .search
        textSearch.font = UIFont.chomperFontForTextStyle("p")
        textSearch.textColor = UIColor.textColor()
        textSearch.placeholder = NSLocalizedString("Search", comment: "Search")
        textSearch.backgroundColor = UIColor.white
        textSearch.layer.cornerRadius = 5.0
        containerView.addArrangedSubview(textSearch)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15.0, height: 30.0))
        textSearch.leftView = paddingView
        textSearch.leftViewMode = .always
        
        locationSearch = UISearchBar()
        locationSearch.layer.cornerRadius = 5.0
        locationSearch.clipsToBounds = true
        locationSearch.layer.borderWidth = 1.0
        locationSearch.layer.borderColor = UIColor.white.cgColor
        locationSearch.placeholder = NSLocalizedString("Current location", comment: "Current location")
        locationSearch.backgroundImage = UIImage.fromColor(UIColor.white)
        locationSearch.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(locationSearch)
        let heightConstraint = locationSearch.heightAnchor.constraint(equalToConstant: 30.0)
        heightConstraint.priority = UILayoutPriorityDefaultHigh
        
        buttonContainerView.isHidden = true
        locationSearch.isHidden = true
        
        NSLayoutConstraint.useAndActivateConstraints([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            constraint,
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cancelButton.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor),
            cancelButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            searchButton.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor),
            searchButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            textSearch.heightAnchor.constraint(equalToConstant: 30.0),
            heightConstraint
        ])
    }
    
    // MARK: - Helpers
    
    func enableSearch() {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: { [weak self] in
            self?.layer.shadowOpacity = 0
            self?.buttonContainerView.isHidden = false
            self?.locationSearch.isHidden = false
            self?.textSearch.becomeFirstResponder()
            }, completion: { [weak self] finished in
                self?.setShadow()
        })
    }
    
    func cancelSearch() {
        setShadow(UIColor.softGrey().cgColor, opacity: 0.75, height: 3.5, shadowRect: CGRect(x: 0, y: 65.0, width: bounds.width, height: 3.5))
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: { [weak self] in
            self?.buttonContainerView.isHidden = true
            self?.locationSearch.isHidden = true
            self?.textSearch.resignFirstResponder()
            }, completion: { [weak self] finished in
                self?.locationSearch.text = nil
                self?.textSearch.text = nil
        })
    }
    
    @IBAction
    func cancelAction(_ sender: UIButton) {
        cancelAction?()
    }
    
    @IBAction
    func searchAction(_ sender: UIButton) {
        searchAction?()
    }
}

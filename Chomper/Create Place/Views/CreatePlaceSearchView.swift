//
//  Created by Danning Ge on 7/1/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import RxCocoa
import RxSwift

class LocationSearchView: UIView {
    var buttonContainerView = UIView()
    var containerView = UIStackView()
    var cancelButton = UIButton()
    var locationSearchBar = UISearchBar()
    var searchButton = UIButton()
    var view = UIView()
    let textField = UITextField()

    var textUpdated: Observable<String?> {
        return textField.rx.text.asObservable()
    }

    var textFieldDidBeginEditing: Observable<Void> {
        return textField.rx.controlEvent([.editingDidBegin]).asObservable()
    }
    var cancelTapped: Observable<Void> {
        return cancelButton.rx.tap.asObservable()
    }

    var searchTapped: Observable<Void> {
        return searchButton.rx.tap.asObservable()
    }

    var searchBarBeginEditing: Observable<Void> {
        return locationSearchBar.rx.textDidBeginEditing.asObservable()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor.darkOrange()
        addSubview(view)
        
        containerView.axis = .vertical
        containerView.alignment = .fill
        containerView.distribution = .fill
        containerView.layoutMargins = UIEdgeInsetsMake(8, 15, 8, 15)
        containerView.isLayoutMarginsRelativeArrangement = true
        containerView.spacing = 8.0
        view.addSubview(containerView)
        
        containerView.addArrangedSubview(buttonContainerView)
        let constraint = buttonContainerView.heightAnchor.constraint(equalToConstant: 30.0)
        constraint.priority = UILayoutPriorityDefaultHigh
        
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("p-small")
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), for: UIControlState())
        cancelButton.setTitleColor(UIColor.softGrey(), for: .highlighted)
        buttonContainerView.addSubview(cancelButton)
        
        searchButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        searchButton.setTitle(NSLocalizedString("Search", comment: "Search"), for: UIControlState())
        searchButton.setTitleColor(UIColor.softGrey(), for: .highlighted)
        buttonContainerView.addSubview(searchButton)

        textField.tintColor = UIColor.darkOrange()
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.font = UIFont.chomperFontForTextStyle("p")
        textField.textColor = UIColor.textColor()
        textField.placeholder = NSLocalizedString("Search", comment: "Search")
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 5.0
        containerView.addArrangedSubview(textField)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15.0, height: 30.0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        locationSearchBar.layer.cornerRadius = 5.0
        locationSearchBar.clipsToBounds = true
        locationSearchBar.layer.borderWidth = 1.0
        locationSearchBar.layer.borderColor = UIColor.white.cgColor
        locationSearchBar.placeholder = NSLocalizedString("Current location", comment: "Current location")
        locationSearchBar.backgroundImage = UIImage.fromColor(UIColor.white)
        locationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(locationSearchBar)
        let heightConstraint = locationSearchBar.heightAnchor.constraint(equalToConstant: 30.0)
        heightConstraint.priority = UILayoutPriorityDefaultHigh
        
        buttonContainerView.isHidden = true
        locationSearchBar.isHidden = true
        
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
            textField.heightAnchor.constraint(equalToConstant: 30.0),
            heightConstraint
        ])
    }

    func enableSearch() {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: { [weak self] in
            self?.layer.shadowOpacity = 0
            self?.buttonContainerView.isHidden = false
            self?.locationSearchBar.isHidden = false
            self?.textField.becomeFirstResponder()
            }, completion: { [weak self] finished in
                self?.setShadow()
        })
    }
    
    func cancelSearch() {
        setShadow(UIColor.softGrey().cgColor, opacity: 0.75, height: 3.5, shadowRect: CGRect(x: 0, y: 65.0, width: bounds.width, height: 3.5))
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: { [weak self] in
            self?.buttonContainerView.isHidden = true
            self?.locationSearchBar.isHidden = true
            self?.textField.resignFirstResponder()
            }, completion: { [weak self] finished in
                self?.locationSearchBar.text = nil
                self?.textField.text = nil
        })
    }
}

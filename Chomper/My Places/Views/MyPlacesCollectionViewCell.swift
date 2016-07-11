//
//  MyPlacesCollectionViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class MyPlacesCollectionViewCell: UICollectionViewCell {
    var placeListLabel: UILabel!
    var separatorColor = UIColor.orangeColor()
    var trailingSeparator: UIView!
    var bottomSeparator: UIView!
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        
        //
        // Separators
        
        trailingSeparator = UIView()
        trailingSeparator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trailingSeparator)
        trailingSeparator.backgroundColor = separatorColor
        trailingSeparator.widthAnchor.constraintEqualToConstant(1.0).active = true
        trailingSeparator.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        trailingSeparator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        trailingSeparator.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        
        bottomSeparator = UIView()
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = separatorColor
        bottomSeparator.heightAnchor.constraintEqualToConstant(1.0).active = true
        bottomSeparator.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        bottomSeparator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        bottomSeparator.trailingAnchor.constraintEqualToAnchor(trailingSeparator.leadingAnchor).active = true
        
        //
        // Label
        
        placeListLabel = UILabel()
        placeListLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeListLabel)
        placeListLabel.text =  nil
        placeListLabel.font = UIFont.chomperFontForTextStye("h1")
        placeListLabel.textColor = UIColor.lightGrayColor()
        placeListLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        placeListLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

    }
    
    // MARK: - Helpers
    
    func configureCell(title: String) {
        placeListLabel.text = NSLocalizedString(title, comment: "title")
    }
    
    
}

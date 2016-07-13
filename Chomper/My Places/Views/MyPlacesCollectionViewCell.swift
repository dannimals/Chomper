//
//  MyPlacesCollectionViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class MyPlacesCollectionViewCell: UICollectionViewCell {
    private var addButton: UIButton!
    private(set) var titleTextView: UITextView!
    private var countLabel: UILabel!
    private var separatorColor = UIColor.lightGrayColor()
    var trailingSeparator: UIView!
    var bottomSeparator: UIView!
    
    var addAction: (() -> ())?
    var titleAction: (() -> ())?
    
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
        contentView.addSubview(trailingSeparator)
        trailingSeparator.backgroundColor = separatorColor
        trailingSeparator.widthAnchor.constraintEqualToConstant(0.75).active = true
        trailingSeparator.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        trailingSeparator.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        trailingSeparator.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        
        bottomSeparator = UIView()
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = separatorColor
        bottomSeparator.heightAnchor.constraintEqualToConstant(0.75).active = true
        bottomSeparator.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        bottomSeparator.trailingAnchor.constraintEqualToAnchor(trailingSeparator.leadingAnchor).active = true
        
        //
        // Title text view
        
        titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextView)
        titleTextView.scrollEnabled = false
        titleTextView.tintColor = UIColor.orangeColor()
        titleTextView.text = nil
        titleTextView.textColor = UIColor.lightGrayColor()
        titleTextView.font = UIFont.chomperFontForTextStyle("p")
        let titleLeading = titleTextView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 10.0)
        titleLeading.active = true
        titleLeading.priority = UILayoutPriorityRequired
        let titleTrailing = titleTextView.trailingAnchor.constraintLessThanOrEqualToAnchor(contentView.trailingAnchor, constant: -10.0)
        titleTrailing.active = true
        titleTrailing.priority = UILayoutPriorityRequired
        
        //
        // Count label
        
        countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLabel)
        countLabel.text = nil
        countLabel.font = UIFont.chomperFontForTextStyle("smallest")
        countLabel.textColor = UIColor.orangeColor()
        let countLeading = countLabel.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 13.5)
        countLeading.active = true
        countLeading.priority = UILayoutPriorityRequired


        let views: [String: AnyObject] = [
            "titleView": titleTextView,
            "countLabel": countLabel,
            "bottomSeparator": bottomSeparator
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[titleView][countLabel]->=10@750-[bottomSeparator]|",
            options: [],
            metrics: nil,
            views: views))
            
        
        
        //
        // "+" button
        
        addButton = UIButton()
        addButton.addTarget(self, action: #selector(handleAddPressed), forControlEvents: .TouchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addButton)
        addButton.setTitle("+", forState: .Normal)
        addButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h1", weight: UIFontWeightThin, size: 75.0, maxDynamicTypeRatio: 1.5, minDynamicTypeRatio: 1.5)
        addButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        addButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        let addCenterX = addButton.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor)
        addCenterX.active = true
        addCenterX.priority = UILayoutPriorityRequired
        let addCenterY = addButton.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor)
        addCenterY.active = true
        addCenterY.priority = UILayoutPriorityRequired
        
        addButton.hidden = true

    }
    
    // MARK: - Helpers
    
    func configureCell(title: String, count: Int = 0, hideTrailingSeparator: Bool? = false, hideBottomSeparator: Bool? = false) {
        titleTextView.text = NSLocalizedString(title, comment: "title")
        titleTextView.sizeToFit()
        countLabel.text = count == 0 ? nil : NSLocalizedString(String(count), comment: "count")
        trailingSeparator.hidden = hideTrailingSeparator!
        bottomSeparator.hidden = hideBottomSeparator!
    }
    
    func configureAddCell(hideTrailingSeparator: Bool = false) {
        titleTextView.hidden = true
        countLabel.hidden = true
        addButton.hidden = false
        trailingSeparator.hidden = hideTrailingSeparator
        bottomSeparator.hidden = true
    }
    
    @IBAction
    func handleAddPressed() {
        addAction?()
    }
    
    @IBAction
    func handleTitlePressed() {
        titleAction?()
    }
}

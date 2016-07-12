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
    private var titleButton: UIButton!
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
        addSubview(trailingSeparator)
        trailingSeparator.backgroundColor = separatorColor
        trailingSeparator.widthAnchor.constraintEqualToConstant(0.75).active = true
        trailingSeparator.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        trailingSeparator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        trailingSeparator.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        
        bottomSeparator = UIView()
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = separatorColor
        bottomSeparator.heightAnchor.constraintEqualToConstant(0.75).active = true
        bottomSeparator.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        bottomSeparator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        bottomSeparator.trailingAnchor.constraintEqualToAnchor(trailingSeparator.leadingAnchor).active = true
        
        //
        // title button and label
        
        titleButton = UIButton()
        titleButton.setContentHuggingPriority(1000, forAxis: .Vertical)
        titleButton.addTarget(self, action: #selector(handleTitlePressed), forControlEvents: .TouchUpInside)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleButton)
        titleButton.setTitle(nil, forState: .Normal)
        titleButton.titleLabel?.numberOfLines = 0
        titleButton.titleLabel?.font = UIFont.chomperFontForTextStyle("p")
        titleButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        titleButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        let titleLeading = titleButton.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10.0)
        titleLeading.active = true
        titleLeading.priority = UILayoutPriorityDefaultHigh
        let titleTop = titleButton.topAnchor.constraintEqualToAnchor(topAnchor, constant: 10.0)
        titleTop.active = true
        titleTop.priority = UILayoutPriorityDefaultHigh
        
        countLabel = UILabel()
        countLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countLabel)
        countLabel.text = nil
        countLabel.font = UIFont.chomperFontForTextStyle("smallest")
        countLabel.textColor = UIColor.lightGrayColor()
        let countLeading = countLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10.0)
        countLeading.active = true
        countLeading.priority = UILayoutPriorityDefaultHigh
        let countTop = countLabel.topAnchor.constraintEqualToAnchor(titleButton.bottomAnchor, constant: -7.0)
        countTop.active = true
        countTop.priority = UILayoutPriorityDefaultHigh
        
        // 
        // "+" button
        
        addButton = UIButton()
        addButton.addTarget(self, action: #selector(handleAddPressed), forControlEvents: .TouchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)
        addButton.setTitle("+", forState: .Normal)
        addButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h1", weight: UIFontWeightUltraLight, size: 75.0, maxDynamicTypeRatio: 1.5, minDynamicTypeRatio: 1.5)
        addButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        addButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        let addCenterX = addButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor)
        addCenterX.active = true
        addCenterX.priority = UILayoutPriorityDefaultHigh
        let addCenterY = addButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor)
        addCenterY.active = true
        addCenterY.priority = UILayoutPriorityDefaultHigh
        
        addButton.hidden = true
    }
    
    // MARK: - Helpers
    
    func configureCell(title: String, count: Int = 0, hideTrailingSeparator: Bool? = false, hideBottomSeparator: Bool? = false) {
        titleButton.setTitle(NSLocalizedString(title, comment: "title"), forState: .Normal)
        countLabel.text = count == 0 ? nil : NSLocalizedString(String(count), comment: "count")
        trailingSeparator.hidden = hideTrailingSeparator!
        bottomSeparator.hidden = hideBottomSeparator!
    }
    
    func configureAddCell(hideTrailingSeparator: Bool = false) {
        titleButton.hidden = true
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

//
//  MyPlacesCollectionViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsCollectionViewCell: UICollectionViewCell {
    private(set) var addButton: UIButton!
    private(set) var titleLabel: UILabel!
    private(set) var listImageView: UIImageView!
    private var countLabel: UILabel!
    private var separatorColor = UIColor.lightGrayColor()
    var trailingSeparator: UIView!
    var bottomSeparator: UIView!
    private var isAdd: Bool = false {
        didSet {
            if isAdd {
                addButton.hidden = false
                titleLabel.hidden = true
                countLabel.hidden = true
                bottomSeparator.hidden = true
            } else {
                addButton.hidden = true
                titleLabel.hidden = false
                countLabel.hidden = false

            }
        }
    }
    
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
        contentView.addSubview(trailingSeparator)
        trailingSeparator.backgroundColor = separatorColor
        
        bottomSeparator = UIView()
        contentView.addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = separatorColor
        
        //
        // Lists Image View
        
        listImageView = UIImageView()
        contentView.addSubview(listImageView)
        
        //
        // Title text view
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(249, forAxis: .Vertical)
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = contentView.frame.width - 20
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = UIFont.chomperFontForTextStyle("p")
        
        //
        // Count label
        
        countLabel = UILabel()
        countLabel.numberOfLines = 1
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLabel)
        countLabel.font = UIFont.chomperFontForTextStyle("smallest")
        countLabel.textColor = UIColor.orangeColor()

        
        //
        // "+" button
        
        addButton = UIButton()
        addButton.addTarget(self, action: #selector(handleAddPressed), forControlEvents: .TouchUpInside)
        contentView.addSubview(addButton)
        addButton.setTitle("+", forState: .Normal)
        addButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h1", weight: UIFontWeightThin, size: 75.0, maxDynamicTypeRatio: 1.5, minDynamicTypeRatio: 1.5)
        addButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        addButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        let addCenterX = addButton.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor)
        addCenterX.priority = UILayoutPriorityRequired
        let addCenterY = addButton.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor)
        addCenterY.priority = UILayoutPriorityRequired
        
        addButton.hidden = true
        
        NSLayoutConstraint.useAndActivateConstraints([
            listImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor),
            listImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),
            listImageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            listImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            trailingSeparator.widthAnchor.constraintEqualToConstant(0.75),
            trailingSeparator.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            trailingSeparator.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            trailingSeparator.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            countLabel.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            countLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 5),
            bottomSeparator.heightAnchor.constraintEqualToConstant(0.75),
            bottomSeparator.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor),
            bottomSeparator.trailingAnchor.constraintEqualToAnchor(trailingSeparator.leadingAnchor),
            bottomSeparator.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            addCenterX,
            addCenterY
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isAdd = false
        titleLabel.text = nil
        countLabel.text = nil
        trailingSeparator.hidden = false
        bottomSeparator.hidden = false
        listImageView.hidden = false
    }
    
    
    // MARK: - Helpers
    
    func configureCell(title: String, count: Int = 0, hideTrailingSeparator: Bool? = false, hideBottomSeparator: Bool? = false, image: UIImage?) {
        isAdd = false
        titleLabel.text = NSLocalizedString(title, comment: "title")
        countLabel.text = count == 0 ? nil : NSLocalizedString(String(count), comment: "count")
        trailingSeparator.hidden = hideTrailingSeparator!
        bottomSeparator.hidden = hideBottomSeparator!
        if let image = image {
            listImageView.image = image
        }
    }
    
    func configureAddCell(hideTrailingSeparator: Bool = false) {
        isAdd = true
        listImageView.hidden = true
        trailingSeparator.hidden = hideTrailingSeparator
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

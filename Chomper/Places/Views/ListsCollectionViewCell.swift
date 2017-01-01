//
//  MyPlacesCollectionViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsCollectionViewCell: UICollectionViewCell {
    fileprivate(set) var addButton: UIButton!
    fileprivate(set) var titleLabel: UILabel!
    fileprivate(set) var listImageView: UIImageView!
    fileprivate var countLabel: UILabel!
    fileprivate var separatorColor = UIColor.lightGray
    var trailingSeparator: UIView!
    var bottomSeparator: UIView!
    fileprivate var isAdd: Bool = false {
        didSet {
            if isAdd {
                addButton.isHidden = false
                titleLabel.isHidden = true
                countLabel.isHidden = true
                bottomSeparator.isHidden = true
            } else {
                addButton.isHidden = true
                titleLabel.isHidden = false
                countLabel.isHidden = false

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
    
    
    fileprivate func initialize() {
        
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
        titleLabel.setContentCompressionResistancePriority(249, for: .vertical)
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = contentView.frame.width - 20
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = UIFont.chomperFontForTextStyle("p")
        
        //
        // Count label
        
        countLabel = UILabel()
        countLabel.numberOfLines = 1
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLabel)
        countLabel.font = UIFont.chomperFontForTextStyle("smallest")
        countLabel.textColor = UIColor.orange

        
        //
        // "+" button
        
        addButton = UIButton()
        addButton.addTarget(self, action: #selector(handleAddPressed), for: .touchUpInside)
        contentView.addSubview(addButton)
        addButton.setTitle("+", for: UIControlState())
        addButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h1", weight: UIFontWeightThin, size: 75.0, maxDynamicTypeRatio: 1.5, minDynamicTypeRatio: 1.5)
        addButton.setTitleColor(UIColor.orange, for: UIControlState())
        addButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        let addCenterX = addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        addCenterX.priority = UILayoutPriorityRequired
        let addCenterY = addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        addCenterY.priority = UILayoutPriorityRequired
        
        addButton.isHidden = true
        
        NSLayoutConstraint.useAndActivateConstraints([
            listImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trailingSeparator.widthAnchor.constraint(equalToConstant: 0.75),
            trailingSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            trailingSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trailingSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 0.75),
            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingSeparator.leadingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addCenterX,
            addCenterY
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isAdd = false
        titleLabel.text = nil
        countLabel.text = nil
        trailingSeparator.isHidden = false
        bottomSeparator.isHidden = false
        listImageView.isHidden = false
    }
    
    
    // MARK: - Helpers
    
    func configureCell(_ title: String, count: Int = 0, hideTrailingSeparator: Bool? = false, hideBottomSeparator: Bool? = false, image: UIImage?) {
        isAdd = false
        titleLabel.text = NSLocalizedString(title, comment: "title")
        countLabel.text = count == 0 ? nil : NSLocalizedString(String(count), comment: "count")
        trailingSeparator.isHidden = hideTrailingSeparator!
        bottomSeparator.isHidden = hideBottomSeparator!
        if let image = image {
            listImageView.image = image
        }
    }
    
    func configureAddCell(_ hideTrailingSeparator: Bool = false) {
        isAdd = true
        listImageView.isHidden = true
        trailingSeparator.isHidden = hideTrailingSeparator
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

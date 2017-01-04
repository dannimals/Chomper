//
//  MyPlacesCollectionViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsCollectionViewCell: UICollectionViewCell {
    private var titleLabel: UILabel!
    private var listImageView: UIImageView!
    private var blurredEffectView: UIVisualEffectView!
    private var countLabel: UILabel!

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
        // Lists Image View
        
        listImageView = UIImageView()
        contentView.addSubview(listImageView)
        let blurEffect = UIBlurEffect(style: .dark)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 0.5
        contentView.addSubview(blurredEffectView)
        
        //
        // Title text view
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(249, for: .vertical)
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = contentView.frame.width - 20
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.chomperFontForTextStyle("h4")
        
        //
        // Count label
        
        countLabel = UILabel()
        countLabel.numberOfLines = 1
        contentView.addSubview(countLabel)
        countLabel.font = UIFont.chomperFontForTextStyle("p small")
        countLabel.textColor = UIColor.white

        
        NSLayoutConstraint.useAndActivateConstraints([
            blurredEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurredEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        titleLabel.textColor = UIColor.white
        countLabel.text = nil
        countLabel.textColor = UIColor.white
        listImageView.isHidden = false
        blurredEffectView.alpha = 0.5
    }
    
    // MARK: - Helpers
    
    func configureCell(_ title: String, count: Int = 0, image: UIImage?) {
        titleLabel.text = NSLocalizedString(title, comment: "title")
        countLabel.text = count == 0 ? nil : NSLocalizedString(String(count), comment: "count")
        if title == defaultSavedList {
            countLabel.textColor = UIColor.lightGray
            titleLabel.textColor = UIColor.lightGray
            blurredEffectView.alpha = 0
        }
        if let image = image {
            listImageView.image = image
        }
    }
    
    @IBAction
    func handleTitlePressed() {
        titleAction?()
    }
}

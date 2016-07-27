//
//  AddToListCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/27/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class AddToListCell: UITableViewCell {
    private var titleLabel: UILabel!
    private var separator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    // MARK: - Handlers
    
    func setup() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.orangeColor()
        titleLabel.font = UIFont.chomperFontForTextStyle("h4")
        contentView.addSubview(titleLabel)
        
        separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(separator)
        
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -15.0),
            titleLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor),
            separator.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 15.0),
            separator.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -15.0),
            separator.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            separator.heightAnchor.constraintEqualToConstant(0.75)
            ])
    }
    
    func configureCell(title: String) {
        titleLabel.text = NSLocalizedString(title, comment: "title")
    }
    
}



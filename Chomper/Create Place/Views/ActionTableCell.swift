//
//  ActionTableCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/26/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ActionTableCell: UITableViewCell {
    private var label: UILabel!
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
        label.text = nil
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.whiteColor()
        
        label = UILabel()
        contentView.addSubview(label)
        label.textAlignment = .Left
        label.font = UIFont.chomperFontForTextStyle("h4")
        label.textColor = UIColor.orangeColor()
        
        separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(separator)
        
        NSLayoutConstraint.useAndActivateConstraints([
            label.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 15),
            label.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            label.topAnchor.constraintEqualToAnchor(topAnchor),
            label.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            separator.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 15.0),
            separator.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -15.0),
            separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            separator.heightAnchor.constraintEqualToConstant(0.75)
        ])
    }
    
    func setTitleForAction(title: String) {
        label.text = title
    }

}

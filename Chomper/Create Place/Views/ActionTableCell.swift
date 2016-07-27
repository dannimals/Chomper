//
//  ActionTableCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/26/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ActionTableCell: UITableViewCell {
    private var button: UIButton!
    private var buttonAction: (() -> Void)?
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
        button.setTitle(nil, forState: .Normal)
        buttonAction = nil
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.whiteColor()
        
        button = UIButton()
        contentView.addSubview(button)
        button.titleLabel?.textAlignment = .Left
        button.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        button.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)
        
        separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(separator)
        
        NSLayoutConstraint.useAndActivateConstraints([
            button.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            button.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            button.topAnchor.constraintEqualToAnchor(topAnchor),
            button.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            separator.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 15.0),
            separator.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -15.0),
            separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            separator.heightAnchor.constraintEqualToConstant(0.75)
            ])
    }
    
    func setTitleForAction(title: String, action: () -> Void) {
        button.setTitle(title, forState: .Normal)
        buttonAction = action
    }
    
    func buttonTapped() {
        buttonAction?()
    }
}

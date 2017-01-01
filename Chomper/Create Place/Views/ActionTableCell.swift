//
//  ActionTableCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/26/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ActionTableCell: UITableViewCell {
    fileprivate var label: UILabel!
    fileprivate var separator: UIView!
    
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
    
    fileprivate func setup() {
        contentView.backgroundColor = UIColor.white
        
        label = UILabel()
        contentView.addSubview(label)
        label.textAlignment = .left
        label.font = UIFont.chomperFontForTextStyle("h4")
        label.textColor = UIColor.orange
        
        separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        contentView.addSubview(separator)
        
        NSLayoutConstraint.useAndActivateConstraints([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.75)
        ])
    }
    
    func setTitleForAction(_ title: String) {
        label.text = title
    }

}

//
//  AddToListCell.swift
//  Chomper
//
//  Created by Danning Ge on 7/27/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class AddToListCell: UITableViewCell {
    fileprivate var titleLabel: UILabel!
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
        
        titleLabel.text = nil
    }
    
    // MARK: - Handlers
    
    func setup() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.darkOrange()
        titleLabel.font = UIFont.chomperFontForTextStyle("h4")
        contentView.addSubview(titleLabel)
        
        separator = UIView()
        separator.backgroundColor = UIColor.softGrey()
        contentView.addSubview(separator)
        
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.75)
            ])
    }
    
    func configureCell(_ title: String) {
        titleLabel.text = NSLocalizedString(title, comment: "title")
    }
}

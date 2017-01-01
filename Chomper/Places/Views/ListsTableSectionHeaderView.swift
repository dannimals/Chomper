//
//  ListsTableSectionHeaderView.swift
//  Chomper
//
//  Created by Danning Ge on 7/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsTableSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    var titleLabel: UILabel!
    var countLabel: UILabel!
    var backgroundViewColor: UIColor? = UIColor.orange {
        didSet {
            contentView.backgroundColor = backgroundViewColor
        }
    }
    
    // MARK: - Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    // MARK: - Helpers
    
    fileprivate func initialize() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.chomperFontForTextStyle("h4")
        titleLabel.text = nil
        titleLabel.textColor = UIColor.white
        
        countLabel = UILabel()
        contentView.addSubview(countLabel)
        countLabel.font = UIFont.chomperFontForTextStyle("h4")
        countLabel.text = nil
        countLabel.textColor = UIColor.white
        
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        countLabel.text = nil
    }
    
    func configureHeader(_ title: String, count: Int) {
        let lightOrange = UIColor.orange.withAlphaComponent(0.7)
        backgroundViewColor = lightOrange
        if count > 0 {
            countLabel.text = String(count)
        }
        titleLabel.text = title
    }
    
}

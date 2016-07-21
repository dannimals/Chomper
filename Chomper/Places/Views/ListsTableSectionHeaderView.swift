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
    var backgroundViewColor: UIColor? = UIColor.orangeColor() {
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
    
    private func initialize() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.chomperFontForTextStyle("h4")
        titleLabel.text = nil
        titleLabel.textColor = UIColor.whiteColor()
        
        countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLabel)
        countLabel.font = UIFont.chomperFontForTextStyle("h4")
        countLabel.text = nil
        countLabel.textColor = UIColor.whiteColor()
        
        titleLabel.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 15.0).active = true
        titleLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
        countLabel.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -15.0).active = true
        countLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        countLabel.text = nil
    }
    
    func configureHeader(title: String, count: Int) {
        let lightOrange = UIColor.orangeColor().colorWithAlphaComponent(0.7)
        backgroundViewColor = lightOrange
        if count > 0 {
            countLabel.text = String(count)
        }
        titleLabel.text = title
    }
    
}

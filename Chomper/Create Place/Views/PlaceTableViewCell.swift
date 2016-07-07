//
//  PlaceTableViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 6/28/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
        
        // TODO: Set fonts, colors etc.
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        nameLabel.font = UIFont.chomperFontForTextStye("p")
        addressLabel.text = nil
        addressLabel.font = UIFont.chomperFontForTextStye("smallest")
        priceLabel.text = nil
        ratingLabel.text = nil
        distanceLabel.text = nil
    }


    func configureCell(withObject object: SearchResult) {
        nameLabel.text = object.name
        addressLabel.text = object.address
        
        // TODO: config rest
    }
}

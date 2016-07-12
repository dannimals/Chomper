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
    @IBOutlet weak var separator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        separator.backgroundColor = UIColor.lightGrayColor()
        separator.heightAnchor.constraintEqualToConstant(0.75).active = true

        nameLabel.font = UIFont.chomperFontForTextStyle("p")
        nameLabel.textColor = UIColor.darkGrayColor()
        
        addressLabel.font = UIFont.chomperFontForTextStyle("smallest")
        addressLabel.textColor = UIColor.grayColor()
        
        priceLabel.font = UIFont.chomperFontForTextStyle("smallest")
        priceLabel.textColor = UIColor.orangeColor()
        
        ratingLabel.font = UIFont.chomperFontForTextStyle("smallest")
        ratingLabel.textColor = UIColor.orangeColor()
        
        distanceLabel.font = UIFont.chomperFontForTextStyle("p small")
        distanceLabel.textColor = UIColor.orangeColor()
        
        prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        addressLabel.text = nil
        priceLabel.text = nil
        ratingLabel.text = nil
        distanceLabel.text = nil
    }


    func configureCell(withObject object: SearchResult) {
        nameLabel.text = object.name
        addressLabel.text = object.address ?? "Address unknown"
        ratingLabel.text = object.rating != nil ? "\(floor(object.rating!/2)) stars" : nil
        if object.price == nil {
            priceLabel.hidden = true
        } else {
            priceLabel.text = convertPrice(object.price!)
        }
        // display distance
    }
    
    private func convertPrice(price: Double?) -> String? {
        if price == nil {
            return nil
        }
        switch price! {
            case 1.0:
                return "$"
            case 2.0:
                return "$$"
            case 3.0:
                return "$$$"
            case 4.0:
                return "$$$$"
            default:
                return nil
        }
        
    }
    
}

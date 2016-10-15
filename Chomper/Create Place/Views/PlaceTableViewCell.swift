//
//  PlaceTableViewCell.swift
//  Chomper
//
//  Created by Danning Ge on 6/28/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import CoreLocation
import Common

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var visitedLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    
    var imageUrl: String? = nil
    
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
        
        placeImageView.contentMode = .ScaleAspectFill
        placeImageView.clipsToBounds = true
        placeImageView.layer.cornerRadius = 5
        placeImageView.layer.borderWidth = 1
        placeImageView.layer.borderColor = UIColor.orangeColor().CGColor
        
        ratingLabel.font = UIFont.chomperFontForTextStyle("smallest")
        ratingLabel.textColor = UIColor.orangeColor()
        
        visitedLabel.font = UIFont.chomperFontForTextStyle("smallest")
        visitedLabel.textColor = UIColor.orangeColor()
        
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
        visitedLabel.text = nil
        distanceLabel.text = nil
        placeImageView.image = nil
        imageUrl = nil
    }


    func configureCell(withObject object: PlaceDetailsObjectProtocol, imageCache: ChomperImageCacheProtocol) {
        imageUrl = object.imageUrl
        nameLabel.text = object.name
        addressLabel.text = object.address ?? "Address unknown"
        ratingLabel.text = object.ratingValue != nil ? "\(floor(object.ratingValue!/2)) stars" : nil
        if object.priceValue == nil {
            priceLabel.hidden = true
        } else {
            priceLabel.text = convertPrice(object.priceValue!)
        }
        
        if let image = imageCache[object.venueId] as? UIImage {
            placeImageView?.image = image
        }
        //TODO: display distance
    }
    
    func configurePlaceCell(name: String, address: String?, rating: NSNumber?, price: NSNumber?, location: CLLocation?, visited: NSNumber = NSNumber(int: 0)) {
        
        nameLabel.text = name
        addressLabel.text = address ?? "Address unknown"
        ratingLabel.text = rating != nil ? "\(floor(rating!.doubleValue/2)) stars" : nil
        if price == nil {
            priceLabel.hidden = true
        } else {
            priceLabel.text = convertPrice(Double(price!))
        }
        
        if visited.boolValue {
            visitedLabel.text = "Visited"
            // TODO: Change to an icon
        }
        // TODO: display distance

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

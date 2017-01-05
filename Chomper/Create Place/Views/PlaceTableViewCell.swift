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
        
        separator.backgroundColor = UIColor.softGrey()
        separator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true

        nameLabel.font = UIFont.chomperFontForTextStyle("p")
        nameLabel.textColor = UIColor.textColor()
        
        addressLabel.font = UIFont.chomperFontForTextStyle("smallest")
        addressLabel.textColor = UIColor.darkGrey()
        
        priceLabel.font = UIFont.chomperFontForTextStyle("smallest")
        priceLabel.textColor = UIColor.darkOrange()
        
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.clipsToBounds = true
        placeImageView.layer.cornerRadius = 5
        placeImageView.layer.borderWidth = 1
        placeImageView.layer.borderColor = UIColor.darkOrange().cgColor
        
        ratingLabel.font = UIFont.chomperFontForTextStyle("smallest")
        ratingLabel.textColor = UIColor.darkOrange()
        
        visitedLabel.font = UIFont.chomperFontForTextStyle("smallest")
        visitedLabel.textColor = UIColor.darkOrange()
        
        distanceLabel.font = UIFont.chomperFontForTextStyle("p small")
        distanceLabel.textColor = UIColor.darkOrange()
        
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
            priceLabel.isHidden = true
        } else {
            priceLabel.text = convertPrice(object.priceValue!)
        }
        
        
        if let image = (imageCache as? NSCache<AnyObject, AnyObject>)?.object(forKey: object.venueId as AnyObject) as? UIImage {
            placeImageView?.image = image
        }
        //TODO: display distance
    }
    
    func configurePlaceCell(_ name: String, address: String?, rating: NSNumber?, price: NSNumber?, location: CLLocation?, visited: NSNumber = NSNumber(value: 0 as Int32)) {
        
        nameLabel.text = name
        addressLabel.text = address ?? "Address unknown"
        ratingLabel.text = rating != nil ? "\(floor(rating!.doubleValue/2)) stars" : nil
        if price == nil {
            priceLabel.isHidden = true
        } else {
            priceLabel.text = convertPrice(Double(price!))
        }
        
        if visited.boolValue {
            visitedLabel.text = "Visited"
            // TODO: Change to an icon
        }
        // TODO: display distance

    }
    
    fileprivate func convertPrice(_ price: Double?) -> String? {
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

//
//  PlaceDetailsView.swift
//  Chomper
//
//  Created by Danning Ge on 8/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import MapKit

class PlaceDetailsView: UIView {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak private(set)var addressLabel: UILabel!
    @IBOutlet weak private(set)var phoneLabel: UILabel!
    @IBOutlet weak private(set)var priceLabel: UILabel!
    @IBOutlet weak private(set)var listsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var notesView: UITextView!
    
    var address: String? {
        didSet {
            if address != nil {
                addressLabel.text = address!
                addressLabel.hidden = false
            }
        }
    }
    
    var phone: String? {
        didSet {
            if phone != nil {
                phoneLabel.text = phone!
                phoneLabel.hidden = false
            }
        }
    }
    
    var price: Double? {
        didSet {
            if price != nil {
                priceLabel.text = String(price!)
                priceLabel.hidden = false
            }
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, 400)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        addressLabel.font = UIFont.chomperFontForTextStyle("p small")
        addressLabel.textColor = UIColor.darkTextColor()
        
        phoneLabel.font = UIFont.chomperFontForTextStyle("p small")
        phoneLabel.textColor = UIColor.darkTextColor()

        priceLabel.font = UIFont.chomperFontForTextStyle("p small")
        priceLabel.textColor = UIColor.darkTextColor()

        listsLabel.font = UIFont.chomperFontForTextStyle("p small")
        listsLabel.textColor = UIColor.darkTextColor()

        notesView.font = UIFont.chomperFontForTextStyle("h5")
        notesView.text = NSLocalizedString("Notes", comment: "notes")
        
        addressLabel.hidden = true
        phoneLabel.hidden = true
        priceLabel.hidden = true
        listsLabel.hidden = true
        
    }
    
    

}

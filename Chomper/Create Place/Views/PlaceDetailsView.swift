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
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private(set)var addressLabel: UILabel!
    @IBOutlet private(set)var phoneLabel: UILabel!
    @IBOutlet private(set)var priceLabel: UILabel!
    @IBOutlet private(set)var listsLabel: UILabel!
    @IBOutlet private(set)var ratingLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var notesView: UITextView!
    @IBOutlet var detailsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private(set)var detailsContainerView: UIView!
    
    var mapViewAction: (() -> ())?
    var phoneAction: (() -> ())?
    
    var formattedAddress: NSAttributedString? {
        didSet {
            if formattedAddress != nil {
                addressLabel.attributedText = formattedAddress
                addressLabel.hidden = false
            }
        }
    }
    
    var location: CLLocation? {
        didSet {
            if let coord = location?.coordinate {
               setMapViewToCoord(coord)
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
                switch price! {
                case 1.0:
                    priceLabel.text = "$"
                case 2.0:
                    priceLabel.text = "$$"
                case 3.0:
                    priceLabel.text = "$$$"
                case 4.0:
                    priceLabel.text = "$$$$"
                default:
                    priceLabel.text = nil
                }
                priceLabel.hidden = false
            }
        }
    }
    
    var rating: Double? {
        didSet {
            if rating != nil {
                ratingLabel.text = "\(floor(rating!/2)) stars"
                ratingLabel.hidden = false
            }
        }
    }
    

    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width, notesView.frame.maxY)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailsContainerView.setShadow()
        
        addressLabel.font = UIFont.chomperFontForTextStyle("p small")
        addressLabel.textColor = UIColor.darkGrayColor()
        addressLabel.numberOfLines = 2

        phoneLabel.font = UIFont.chomperFontForTextStyle("p small")
        phoneLabel.userInteractionEnabled = true
        let phoneGR = UITapGestureRecognizer(target: self, action: #selector(phoneLabelTapped))
        phoneLabel.addGestureRecognizer(phoneGR)
        
        priceLabel.font = UIFont.chomperFontForTextStyle("p small")
        priceLabel.textColor = UIColor.lightGrayColor()

        listsLabel.font = UIFont.chomperFontForTextStyle("p small")
        listsLabel.textColor = UIColor.darkTextColor()

        let mapGR = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(mapGR)
        
        notesView.font = UIFont.chomperFontForTextStyle("h4")
        notesView.textContainerInset = UIEdgeInsetsMake(10, 8, 0, 8)
        notesView.textColor = UIColor.darkGrayColor()
        
        ratingLabel.font = UIFont.chomperFontForTextStyle("p small")
        ratingLabel.textColor = UIColor.lightGrayColor()
        
        addressLabel.hidden = true
        phoneLabel.hidden = true
        priceLabel.hidden = true
        listsLabel.hidden = true
        ratingLabel.hidden = true
        
    }
    
    // MARK: - Helpers
    
    func mapViewTapped() {
        mapViewAction?()
    }
    
    func phoneLabelTapped() {
        phoneAction?()
    }
    
    private func setMapViewToCoord(coord: CLLocationCoordinate2D) {
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = coord
        mapView.addAnnotation(dropPin)
        
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
    }

}
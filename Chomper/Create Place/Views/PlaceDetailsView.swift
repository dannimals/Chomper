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
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet fileprivate(set)var addressLabel: UILabel!
    @IBOutlet fileprivate(set)var phoneLabel: UILabel!
    @IBOutlet fileprivate(set)var priceLabel: UILabel!
    @IBOutlet fileprivate(set)var listsLabel: UILabel!
    @IBOutlet fileprivate(set)var ratingLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var notesView: UITextView!
    @IBOutlet var detailsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate(set)var detailsContainerView: UIView!
    
    var mapViewAction: (() -> ())?
    var phoneAction: (() -> ())?
    let placeHolderText = NSLocalizedString("Add a note", comment: "add a note")

    var formattedAddress: NSAttributedString? {
        didSet {
            if formattedAddress != nil {
                addressLabel.attributedText = formattedAddress
                addressLabel.isHidden = false
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
                phoneLabel.isHidden = false
            }
        }
    }
    
    var price: Double? {
        didSet {
            if price != nil && price != 0 {
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
                priceLabel.isHidden = false
            }
        }
    }
    
    var rating: Double? {
        didSet {
            if rating != nil && rating != 0 {
                ratingLabel.text = "\(floor(rating!/2)) stars"
                ratingLabel.isHidden = false
            }
        }
    }
    

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: notesView.frame.maxY)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLabel.font = UIFont.chomperFontForTextStyle("p small")
        addressLabel.textColor = UIColor.textColor()
        addressLabel.numberOfLines = 2
        
        detailsContainerView.setShadow()
        
        imageCollectionView.backgroundColor = UIColor.softWhite()
        imageCollectionView.registerCell(ImageCollectionCell.self)
        
        listsLabel.font = UIFont.chomperFontForTextStyle("p small")
        listsLabel.textColor = UIColor.darkGrey()
        
        let mapGR = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(mapGR)
        
        notesView.font = UIFont.chomperFontForTextStyle("h4")
        notesView.textContainerInset = UIEdgeInsetsMake(10, 8, 0, 8)
        notesView.textColor = UIColor.textColor()

        phoneLabel.font = UIFont.chomperFontForTextStyle("p small")
        phoneLabel.textColor = UIColor.darkOrange()
        phoneLabel.isUserInteractionEnabled = true
        let phoneGR = UITapGestureRecognizer(target: self, action: #selector(phoneLabelTapped))
        phoneLabel.addGestureRecognizer(phoneGR)
        
        priceLabel.font = UIFont.chomperFontForTextStyle("p small")
        priceLabel.textColor = UIColor.darkGrey()

        ratingLabel.font = UIFont.chomperFontForTextStyle("p small")
        ratingLabel.textColor = UIColor.darkGrey()
        
        addressLabel.isHidden = true
        phoneLabel.isHidden = true
        priceLabel.isHidden = true
        listsLabel.isHidden = true
        ratingLabel.isHidden = true
    }
    
    // MARK: - Helpers
    
    func configureWithViewModel(_ viewModel: PlaceDetailsViewModel) {
        phoneAction = {
            let formattedPhone = viewModel.phone?.replacingOccurrences(of: "[^0-9]", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
            if let formattedPhone = formattedPhone, let phoneUrl = URL(string: "tel://\(formattedPhone)") {
                if UIApplication.shared.canOpenURL(phoneUrl) {
                    UIApplication.shared.openURL(phoneUrl)
                }
            }
        }
        
        let attrText = NSMutableAttributedString()
        if let address = viewModel.address {
            attrText.append(NSAttributedString(string: address))
            if let city = viewModel.city, let state = viewModel.state {
                attrText.append(NSAttributedString(string: "\n\(city), \(state)"))
            }
        } else {
            if let city = viewModel.city, let state = viewModel.state  {
                attrText.append(NSAttributedString(string: "\(city), \(state)"))
            }
        }
        
        formattedAddress = attrText
        location = viewModel.location
        price = viewModel.priceValue
        phone = viewModel.phone
        notesView.text = viewModel.userNotes ?? placeHolderText
        rating = viewModel.ratingValue
    }
    
    func mapViewTapped() {
        mapViewAction?()
    }
    
    func phoneLabelTapped() {
        phoneAction?()
    }
    
    private func setMapViewToCoord(_ coord: CLLocationCoordinate2D) {
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

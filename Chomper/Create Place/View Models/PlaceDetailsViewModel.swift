//
//  PlaceDetailsViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 10/7/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import WebServices

class PlaceDetailsViewModel: NSObject {
    
    // MARK: - Properties
    
    var address: String?
    var city: String?
    var location: CLLocation!
    var phone: String?
    var photos: [Photo]?
    var priceValue: Double?
    var name: String!
    var ratingValue: Double?
    var state: String?
    var type: String!
    var userNotes: String?
    private var place: PlaceDetailsObjectProtocol!
    private var webService: ChomperWebServiceProtocol!
    
    
    required init(place: PlaceDetailsObjectProtocol, webService: ChomperWebServiceProtocol) {
        self.address = place.address
        self.city = place.city
        self.location = place.location
        self.name = place.name
        self.phone = place.phone
        self.place = place
        self.priceValue = place.priceValue
        self.ratingValue = place.ratingValue
        self.state = place.state
        self.type = place.type
        self.userNotes = place.userNotes
        self.webService = webService
        
        super.init()
    }
    
    
    // MARK: - Helpers
    
    func getImageWithUrl(url: NSURL, completionHandler: ((image: UIImage) -> ())?) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if error == nil, let data = data, let image = UIImage(data: data) {
               completionHandler?(image: image)
            }
        }.resume()
    }
    
    func getPlaceImages(completionHandler: (() -> ())?) {
        webService.getPhotosForPlace(place.venueId) { [weak self] (photos, response, error) in
            if error == nil {
                if let photos = photos where photos.count != 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.photos = photos
                    }
                    completionHandler?()
                }
            } else {
                // TODO: handle error
            }
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard section == 0 else { return 0 }
        return photos?.count ?? 0
    }
    
}
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
    var photos: [SearchPhoto]?
    var priceValue: Double?
    var name: String!
    var ratingValue: Double?
    var state: String?
    var type: String!
    var userNotes: String?
    // TODO: place should be private
    var place: PlaceDetailsObjectProtocol!
    fileprivate var webService: ChomperWebServiceProvider!
    
    
    required init(place: PlaceDetailsObjectProtocol, webService: ChomperWebServiceProvider) {
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
    
    func getImageWithUrl(_ url: URL, completionHandler: ((_ image: UIImage) -> ())?) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil, let data = data, let image = UIImage(data: data) {
               completionHandler?(image)
            }
        }) .resume()
    }
    
    func getPlaceImages(_ completionHandler: (() -> ())?) {
        let _ = webService.getPhotosForPlace(id: place.venueId) { [weak self] (photos, error) in
            if error == nil {
                if let photos = photos, photos.count != 0 {
                    DispatchQueue.main.async {
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
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section == 0 else { return 0 }
        return photos?.count ?? 0
    }
}

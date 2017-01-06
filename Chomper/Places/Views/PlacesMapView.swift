//
//  PlacesMapView.swift
//  Chomper
//
//  Created by Danning Ge on 1/6/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import MapKit

class PlacesMapView: UIView {
    let mapView: MKMapView!
    
    override init(frame: CGRect) {
        mapView = MKMapView()
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(mapView)
        NSLayoutConstraint.useAndActivateConstraints([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeAnnotations() {
//        let pin = MKPointAnnotation()
//        pin.coordinate = placeLocation.coordinate
//        mapView.addAnnotation(pin)
//        let latDelta: CLLocationDegrees = 0.01
//        let longDelta: CLLocationDegrees = 0.01
//        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//        let region = MKCoordinateRegion(center: pin.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
    }
}

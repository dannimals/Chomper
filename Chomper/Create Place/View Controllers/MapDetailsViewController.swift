//
//  MapDetailsViewController.swift
//  Chomper
//
//  Created by Danning Ge on 8/23/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import MapKit

class MapDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    
    var mapView: MKMapView!
    var placeLocation: CLLocation!
    
    // MARK: - Initializers
    
    required init(placeLocation: CLLocation) {
        self.placeLocation = placeLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Configure mapView
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        let views: [String: AnyObject] = [
            "mapView": mapView,
            "topLayoutGuide": topLayoutGuide
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[mapView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[topLayoutGuide][mapView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        setPlaceAnnotation()
    }
    
    // MARK: - Handlers
    
    func setPlaceAnnotation() {
        let pin = MKPointAnnotation()
        pin.coordinate = placeLocation.coordinate
        mapView.addAnnotation(pin)
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: pin.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
}

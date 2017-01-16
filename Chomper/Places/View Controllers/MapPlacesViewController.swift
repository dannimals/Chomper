//
//  MapPlacesViewController.swift
//  Chomper
//
//  Created by Danning Ge on 1/16/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import MapKit
import Models

class MapPlacesViewController: BaseViewController {
    
    var viewModel: MapPlacesViewModel
    let mapView = MKMapView()
    
    required init(viewModel: MapPlacesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        if let places = viewModel.places {
            makeAnnotations(forPlaces: places)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        NSLayoutConstraint.useAndActivateConstraints([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    fileprivate func makeAnnotations(forPlaces places: [Place]) {
        for place in places {
            if let lat = place.latitude as? CLLocationDegrees, let long = place.longitude as? CLLocationDegrees {
                let coordinate = CLLocationCoordinate2DMake(lat, long)
                let pin = MKPointAnnotation()
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)
            }
        }
    }
}

extension MapPlacesViewController: MapPlacesDelegate {
    func didUpdateWithPlaces(places: [Place]) {
        makeAnnotations(forPlaces: places)
    }
}

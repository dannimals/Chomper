//
//  Created by Danning Ge on 4/30/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import CoreLocation
import Common
import RxCocoa
import RxSwift

protocol LocationManagerType: class {
    var authorizationStatus: Variable<CLAuthorizationStatus> { get }
    var location: Driver<CLLocationCoordinate2D> { get }

    func requestLocationPermission()
    func startUpdatingLocation()
    func stopUpdationLocation()
}

class ChomperLocationService: LocationManagerType {
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()

    let authorizationStatus = Variable(CLLocationManager.authorizationStatus())
    let location: Driver<CLLocationCoordinate2D>

    init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager
            .rx.didChangeAuthorizationStatus
            .bindTo(authorizationStatus)
            .addDisposableTo(disposeBag)

        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap { locations in
                unwrapOrElse(locations.last.map(Driver.just), fallback: Driver.empty())
            }
            .map { $0.coordinate }
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdationLocation() {
        locationManager.stopUpdatingLocation()
    }
}

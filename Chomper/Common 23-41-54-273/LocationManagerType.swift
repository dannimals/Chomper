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
    var location: Variable<CLLocation> { get }

    func requestLocationPermission()
    func startUpdatingLocation()
    func stopUpdationLocation()
}

enum GeocodeError: Swift.Error {
    case permission
    case getLocation
}

class ChomperLocationService: LocationManagerType {
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()

    let authorizationStatus = Variable(CLLocationManager.authorizationStatus())
    let location = Variable(CLLocation())

    init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager
            .rx.didChangeAuthorizationStatus
            .bindTo(authorizationStatus)
            .addDisposableTo(disposeBag)

        locationManager
            .rx.didUpdateLocations
            .flatMapLatest { locations -> Observable<CLLocation> in
                guard let location = locations.last else { return Observable.error(GeocodeError.getLocation) }
                return Observable.just(location)
            }
            .bindTo(location)
            .addDisposableTo(disposeBag)
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

//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import RxSwift
import WebServices

class CreatePlaceViewModel: ViewModel {
    enum CreatePlaceError: Error {
        case getPlaces
    }

    let searchResults = Variable<[SearchPlace]>([])
    let searchTerm = Variable<String?>(nil)
    let webService: ChomperWebServiceProvider
    let locationService: LocationManagerType

    init(locationService: LocationManagerType = ChomperLocationService(),
         webService: ChomperWebServiceProvider) {
        self.locationService = locationService
        self.webService = webService

        super.init()

        setupBindings()
    }

    func setupBindings() {
        locationService
            .authorizationStatus
            .asObservable()
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .notDetermined:
                    self.locationService.requestLocationPermission()
                case .authorizedWhenInUse:
                    self.locationService.startUpdatingLocation()
                default:
                    self.locationService.stopUpdationLocation()
                }
            })
            .addDisposableTo(disposeBag)
    }

    func numberOfRows() -> Int {
        return searchResults.value.count
    }

    func fetchSearchResults() -> Observable<[SearchPlace]?> {
        return webService
            .getRecommendedPlacesNearLocation(location: locationService.location.value, searchTerm: searchTerm.value) { (searchResults, error) -> [SearchPlace]? in
                guard error == nil else { return nil }

                return (unwrapOrElse(searchResults, fallback: []))
            }
    }
}

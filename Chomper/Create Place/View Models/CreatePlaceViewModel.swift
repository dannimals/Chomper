//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import RxSwift
import WebServices

class CreatePlaceViewModel: ViewModel {
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

    func fetchPlaces() {
        /*guard let location = locationService.location else { return }

        webService
            .getRecommendedPlacesNearLocation(location: location, searchTerm: searchTerm.value) { [unowned self] (searchResults, error) in
                if error == nil {
                    self.searchResults.value = unwrapOrElse(searchResults, fallback: [])
                } else {
                    // TODO: Handle error
                }
        }*/
    }
}

//
//  Created by Danning Ge on 6/30/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import RxSwift
import WebServices

class CreatePlaceViewModel {
    let location = Variable<CLLocation?>(nil)
    let searchResults = Variable<[SearchPlace]>([])
    let searchTerm = Variable<String?>(nil)
    let webService: ChomperWebServiceProvider


    init(webService: ChomperWebServiceProvider) {
        self.webService = webService
    }
    
    // MARK: - Helpers
    
    func numberOfRows() -> Int {
        return searchResults.value.count
    }

    func fetchPlaces() {
        guard let location = location.value else { return }

        webService
            .getRecommendedPlacesNearLocation(location: location, searchTerm: searchTerm.value) { [unowned self] (searchResults, error) in
                if error == nil {
                    self.searchResults.value = unwrapOrElse(searchResults, fallback: [])
                } else {
                    // TODO: Handle error
                }
        }
    }
 }

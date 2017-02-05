//
//  Created by Danning Ge on 2/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import Moya
import SwiftyJSON

public class ChomperProvider {
    public init() {}
    let provider = MoyaProvider<ChomperApi>()
    
    public func getDetailsForPlace(id: String) {
        provider.request(.getDetailsForPlace(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data: data)
                print(json)
                
            case let .failure(error):
                print("Error \(error)")
            }
            
        }
    }

    public func getPhotosForPlace(id: String) {
        provider.request(.getPhotosForPlace(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data: data)
                print(json)
                
            case let .failure(error):
                print("Error \(error)")
            }
            
        }
    }

    public func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?) {
        provider.request(.getRecommendedPlacesNearLocation(location: location, string: searchTerm)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data: data)
                print(json)
                
            case let .failure(error):
                print("Error \(error)")
            }
            
        }
    }
    
}


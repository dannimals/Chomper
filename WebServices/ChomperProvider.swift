//
//  Created by Danning Ge on 2/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import Moya
import Moya_ObjectMapper
import SwiftyJSON

public typealias PhotosCompletionHandler = ([SearchPhoto]?, Swift.Error?) -> Void
public typealias PlacesCompletionHandler = ([SearchPlace]?, Swift.Error?) -> Void
public typealias PlaceCompletionHandler = (SearchPlace?, Swift.Error?) -> Void

public protocol ChomperWebServiceProvider {
    func getDetailsForPlace(id: String, completionHandler: @escaping PlaceCompletionHandler)
    func getPhotosForPlace(id: String, completionHandler: @escaping PhotosCompletionHandler)
    func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: @escaping PlacesCompletionHandler)
}

public class ChomperProvider: ChomperWebServiceProvider {
    public init() {}
    let provider = MoyaProvider<ChomperApi>()
    
    public func getDetailsForPlace(id: String, completionHandler: @escaping PlaceCompletionHandler) {
        provider.request(.getDetailsForPlace(id: id)) { result in
            switch result {
            case let .success(response):
                let response = try? response.mapObject(SearchPlaceResponse.self)
                completionHandler(response?.searchPlace, nil)
            case let .failure(error):
                completionHandler(nil, error)
                fatalErrorInDebug(message: "Get details for place failed with \(error)")
            }
        }
    }

    public func getPhotosForPlace(id: String, completionHandler: @escaping PhotosCompletionHandler) {
        provider.request(.getPhotosForPlace(id: id)) { result in
            switch result {
            case let .success(response):
                let response = try? response.mapObject(SearchPhotoResponse.self)
                completionHandler(response?.photos, nil)
            case let .failure(error):
                completionHandler(nil, error)
                fatalErrorInDebug(message: "Get photos for place failed with \(error)")
            }
        }
    }

    public func getRecommendedPlacesNearLocation(location: CLLocation, searchTerm: String?, completionHandler: @escaping PlacesCompletionHandler) {
        provider.request(.getRecommendedPlacesNearLocation(location: location, string: searchTerm)) { result in
            switch result {
            case let .success(response):
                let response = try? response.mapObject(SearchPlacesResponse.self)
                completionHandler(response?.searchPlaces, nil)
            case let .failure(error):
                completionHandler(nil, error)
                fatalErrorInDebug(message: "Get places failed with \(error)")
            }
        }
    }
}

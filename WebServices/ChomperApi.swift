//
//  Created by Danning Ge on 2/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import CoreLocation
import Moya

public enum ChomperApi {
    case getDetailsForPlace(id: String)
    case getPhotosForPlace(id: String)
    case getRecommendedPlacesNearLocation(location: CLLocation, string: String?)
}

extension ChomperApi: TargetType {
    public var baseURL: URL { return URL(string: "https://api.foursquare.com/v2")! }
    private static let dateFormatter = DateFormatter()
    private static let dateFormat = "YYYYMMDD"
    private static let baseURLString = "https://api.foursquare.com/v2"
    private static let clientId = "MDNOUO12E1RRL20OOJZJHWGM5ZBLLKUHERL31DEHODYHYUK5"
    private static let clientSecret = "DIG45IF1K2FWUBGQLAZGYYJGLUCOZMTQRCPE0WQY5TMNH32B"
    
    public var path: String {
        switch self {
        case .getDetailsForPlace(let id):
            return "/venues/\(id)"
        case .getPhotosForPlace(let id):
            return "/venues/\(id)/photos"
        case .getRecommendedPlacesNearLocation:
            return "/venues/explore/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDetailsForPlace, .getPhotosForPlace, .getRecommendedPlacesNearLocation :
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        ChomperApi.dateFormatter.dateFormat = ChomperApi.dateFormat

        switch self {
        case .getDetailsForPlace, .getPhotosForPlace:
            return ["v": ChomperApi.dateFormatter.string(from: Date()),
                    "client_id": ChomperApi.clientId,
                    "client_secret": ChomperApi.clientSecret]
        case .getRecommendedPlacesNearLocation(let location, let searchTerm):
            return ["v": ChomperApi.dateFormatter.string(from: Date()),
                    "client_id": ChomperApi.clientId,
                    "client_secret": ChomperApi.clientSecret,
                    "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)",
                    "venuePhotos": "1",
                    "query": searchTerm ?? ""]

        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var sampleData: Data {
        switch self {
        case .getDetailsForPlace:
            return Data.dataFromJson(file: "placedetails")
        case .getPhotosForPlace:
            return Data.dataFromJson(file: "placephotos")
        case .getRecommendedPlacesNearLocation:
            return Data.dataFromJson(file: "recommendedplaces")
        }
    }
    
    public var task: Task {
        switch self {
        case .getDetailsForPlace, .getPhotosForPlace, .getRecommendedPlacesNearLocation:
            return .request
        }
    }
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

//
//  Created by Danning Ge on 2/17/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import ObjectMapper

public struct SearchPlaceResponse: Mappable {
    var searchPlace: SearchPlace? = nil
    
    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        searchPlace <- map["response.venue"]
    }
}

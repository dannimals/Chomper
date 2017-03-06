//
//  Created by Danning Ge on 3/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import ObjectMapper

public struct SearchPlacesResponse: ImmutableMappable {
    var searchPlaces: [SearchPlace]
    
    public init(map: Map) throws {
        searchPlaces = try map.value("response.groups.0.value")
    }
}

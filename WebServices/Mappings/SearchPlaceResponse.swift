//
//  Created by Danning Ge on 2/17/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import ObjectMapper

struct SearchPlaceResponse: ImmutableMappable {
    let searchPlace: SearchPlace

    init(map: Map) throws {
        searchPlace = try map.value("response")
    }
}

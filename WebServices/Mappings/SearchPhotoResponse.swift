//
//  Created by Danning Ge on 3/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import ObjectMapper

public struct SearchPhotoResponse: ImmutableMappable {
    var photos: [SearchPhoto]
    
    public init(map: Map) throws {
        photos = try map.value("response.photos.items")
    }
}

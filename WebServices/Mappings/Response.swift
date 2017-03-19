//
//  Created by Danning Ge on 3/19/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import ObjectMapper

public struct Response: ImmutableMappable {
    var jsonDict: [String: Any]

    public init(map: Map) throws {
        jsonDict = try map.value("response")
    }
}

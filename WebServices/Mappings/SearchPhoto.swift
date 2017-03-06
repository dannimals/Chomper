//
//  Created by Danning Ge on 3/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import ObjectMapper

public struct SearchPhoto: Mappable {
    public var id = ""
    public var width = 0
    public var height = 0
    var prefix = ""
    var suffix = ""

    public var url: String {
        return "\(prefix)\(width)x\(height)\(suffix)"
    }

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        id <- map["id"]
        width <- map["width"]
        height <- map["height"]
        prefix <- map["prefix"]
        suffix <- map["suffix"]
    }
}

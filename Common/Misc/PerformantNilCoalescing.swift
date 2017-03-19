//
//  Created by Danning Ge on 3/19/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

// Build performance guidance: Use the empty value one (`unwrapOrEmpty`) where possible.
// In ad-hoc testing, this was a few milliseconds faster than passing an empty string into
// `unwrapOrElse(foo, fallback: "")`. For more info on nil coalescing performance impact:
// https://medium.com/@RobertGummesson/regarding-swift-build-time-optimizations-fc92cdd91e31#.jaggt72x1
public func unwrapOrEmpty(_ optional: String?) -> String {
    guard let opt = optional else { return "" }
    return opt
}

public func unwrapOrElse<T>(_ optional: T?, fallback: T) -> T {
    guard let opt = optional else { return fallback }
    return opt
}

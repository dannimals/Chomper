//
//  Created by Danning Ge on 3/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

public func fatalErrorInDebug(message: String!,
                              additionalAttributes: [String:String]? = nil,
                              file: String = #file,
                              staticFile: StaticString = #file,
                              line: Int = #line) {
    var isDebug = false
    #if MP_BUILD_DEBUG
        isDebug = true
    #endif
    
    let errorLocation = (file as NSString).lastPathComponent + ":\(line)"
    var attributes = additionalAttributes ?? [String:String]()
    attributes["location"] = errorLocation
    attributes["message"] = message
    
    if isDebug {
        fatalError(message, file: staticFile, line: UInt(line))
    } else {
        //TODO: Log to some service
    }
}

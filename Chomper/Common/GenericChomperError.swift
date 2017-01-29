//
//  Created by Danning Ge on 1/23/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

enum GenericChomperError {
    case invalid(errorMessage: String)
    
    var description: String {
        switch self {
        case .invalid(let message):
            return message
        }
    }
}

extension GenericChomperError: Equatable {
    public static func ==(lhs: GenericChomperError, rhs: GenericChomperError) -> Bool {
        return true
    }
}

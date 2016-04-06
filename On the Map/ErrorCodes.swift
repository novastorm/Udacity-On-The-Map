//
//  ErrorCodes.swift
//  On the Map
//
//  Created by Adland Lee on 3/30/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

enum ErrorCodes: Int32 {
    case GenericError = -1
    case NetworkError = -100
}

extension ErrorCodes: CustomStringConvertible {
    var description: String {
        get {
            switch self {
            case .GenericError:
                return "Generic Error"
            case .NetworkError:
                return "Network Error"
            }
        }
    }
}
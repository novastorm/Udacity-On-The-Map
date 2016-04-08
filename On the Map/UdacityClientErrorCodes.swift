//
//  UdacityClientErrorCodes.swift
//  On the Map
//
//  Created by Adland Lee on 4/1/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

extension UdacityClient {

    enum ErrorCodes: Int, CustomStringConvertible {
        case GenericError
        case NetworkError
        case GenericRequestError
        case HTTPUnsucessful
        case NoData

        var description: String {
            get {
                switch self {
                case .GenericError:
                    return "Generic Error"
                case .NetworkError:
                    return "Network Error"
                case .GenericRequestError:
                    return "There was an error with the request."
                case .HTTPUnsucessful:
                    return "Request returned a status code other that 2XX!"
                case .NoData:
                    return "No data returned by the request"
                }
            }
        }
    }
}
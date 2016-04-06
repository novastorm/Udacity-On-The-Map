//
//  Account.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

struct Account {
    
    typealias ObjectIdType = String

    var objectId: ObjectIdType?


    static var formatter = NSDateFormatter()
    
    static func dateFromString(string: String) -> NSDate? {
        if formatter.dateFormat == "" {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
        return formatter.dateFromString(string)
    }

    init(dictionary: [String:AnyObject]) {
        
        let formatter = NSDateFormatter()
        // "2015-03-11T02:48:18.321Z"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        objectId = dictionary[UdacityParseClient.JSONResponseKeys.ObjectId] as? ObjectIdType
    }
    
}
//
//  StudentLocation.swift
//  On the Map
//
//  Created by Adland Lee on 3/28/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    typealias ObjectIdType = String
    typealias UniqueKeyType = String
    typealias FirstNameType = String
    typealias LastNameType = String
    typealias MapStringType = String
    typealias MediaURLType = String
    typealias LatitudeType = Float
    typealias LongitudeType = Float
    typealias CreatedAtType = String
    typealias UpdatedAtType = String

    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Float?
    var longitude: Float?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    init(dictionary: [String:AnyObject]) {
        
        let formatter = NSDateFormatter()
        // "2015-03-11T02:48:18.321Z"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        objectId = dictionary[UdacityParseClient.JSONResponseKeys.ObjectId] as? ObjectIdType
        uniqueKey = dictionary[UdacityParseClient.JSONResponseKeys.UniqueKey] as? UniqueKeyType
        firstName = dictionary[UdacityParseClient.JSONResponseKeys.FirstName] as? FirstNameType
        lastName = dictionary[UdacityParseClient.JSONResponseKeys.LastName] as? LastNameType
        mapString = dictionary[UdacityParseClient.JSONResponseKeys.MapString] as? MapStringType
        latitude = dictionary[UdacityParseClient.JSONResponseKeys.Latitude] as? LatitudeType
        longitude = dictionary[UdacityParseClient.JSONResponseKeys.Longitude] as? LongitudeType
        createdAt = formatter.dateFromString((dictionary[UdacityParseClient.JSONResponseKeys.CreatedAt] as? String)!)
        updatedAt = formatter.dateFromString((dictionary[UdacityParseClient.JSONResponseKeys.UpdatedAt] as? String)!)
    }
    
    static func ListFromResults(results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocationList = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            studentLocationList.append(StudentLocation(dictionary: result))
        }
        
        return studentLocationList
    }
}

// MARK: - UdacityParseStudentLocation: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.objectId == rhs.objectId
}

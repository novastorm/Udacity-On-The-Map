//
//  StudentInformation.swift
//  On the Map
//
//  Created by Adland Lee on 3/28/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

struct StudentInformation {
    
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
        mediaURL = dictionary[UdacityParseClient.JSONResponseKeys.MediaURL] as? MediaURLType
        latitude = dictionary[UdacityParseClient.JSONResponseKeys.Latitude] as? LatitudeType
        longitude = dictionary[UdacityParseClient.JSONResponseKeys.Longitude] as? LongitudeType
        createdAt = formatter.dateFromString((dictionary[UdacityParseClient.JSONResponseKeys.CreatedAt] as? String)!)
        updatedAt = formatter.dateFromString((dictionary[UdacityParseClient.JSONResponseKeys.UpdatedAt] as? String)!)
    }
    
    static func ListFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentInformationList = [StudentInformation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            studentInformationList.append(StudentInformation(dictionary: result))
        }
        
        return studentInformationList
    }
}

// MARK: - UdacityParseStudentLocation: Equatable

extension StudentInformation: Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
    return lhs.objectId == rhs.objectId
}

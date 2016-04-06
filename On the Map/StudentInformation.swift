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
    typealias CreatedAtType = NSDate
    typealias UpdatedAtType = NSDate

    var objectId: ObjectIdType?
    var uniqueKey: UniqueKeyType?
    var firstName: FirstNameType?
    var lastName: LastNameType?
    var mapString: MapStringType?
    var mediaURL: MediaURLType?
    var latitude: LatitudeType?
    var longitude: LongitudeType?
    var createdAt: CreatedAtType?
    var updatedAt: UpdatedAtType?
    
    static var formatter = NSDateFormatter()
    
    static func dateFromString(string: String) -> NSDate? {
        if formatter.dateFormat == "" {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
        return formatter.dateFromString(string)
    }
    
    init(dictionary: [String:AnyObject]) {
        
        objectId = dictionary[UdacityParseClient.JSONResponseKeys.ObjectId] as? ObjectIdType
        uniqueKey = dictionary[UdacityParseClient.JSONResponseKeys.UniqueKey] as? UniqueKeyType
        firstName = dictionary[UdacityParseClient.JSONResponseKeys.FirstName] as? FirstNameType
        lastName = dictionary[UdacityParseClient.JSONResponseKeys.LastName] as? LastNameType
        mapString = dictionary[UdacityParseClient.JSONResponseKeys.MapString] as? MapStringType
        mediaURL = dictionary[UdacityParseClient.JSONResponseKeys.MediaURL] as? MediaURLType
        latitude = dictionary[UdacityParseClient.JSONResponseKeys.Latitude] as? LatitudeType
        longitude = dictionary[UdacityParseClient.JSONResponseKeys.Longitude] as? LongitudeType
        createdAt = StudentInformation.dateFromString((dictionary[UdacityParseClient.JSONResponseKeys.CreatedAt] as? String)!)
        updatedAt = StudentInformation.dateFromString((dictionary[UdacityParseClient.JSONResponseKeys.UpdatedAt] as? String)!)
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

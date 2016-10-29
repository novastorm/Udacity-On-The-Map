//
//  StudentInformation.swift
//  On the Map
//
//  Created by Adland Lee on 3/28/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//



import Foundation

// MARK: Notification Identifiers

extension Notification.Name {
    static let studentInformationUpdated = Notification.Name("studentInformationUpdated")
}

// MARK: StudentInformation

struct StudentInformation {
    
    static var list = [StudentInformation]() {
        didSet {
            NotificationCenter.default.post(name: .studentInformationUpdated, object: nil)
        }
    }
    
    struct Keys {
        static let ObjectId = UdacityParseClient.ResultsKeys.ObjectId
        static let UniqueKey = UdacityParseClient.ResultsKeys.UniqueKey
        static let FirstName = UdacityParseClient.ResultsKeys.FirstName
        static let LastName = UdacityParseClient.ResultsKeys.LastName
        static let MapString = UdacityParseClient.ResultsKeys.MapString
        static let MediaURL = UdacityParseClient.ResultsKeys.MediaURL
        static let Latitude = UdacityParseClient.ResultsKeys.Latitude
        static let Longitude = UdacityParseClient.ResultsKeys.Longitude
        static let CreatedAt = UdacityParseClient.ResultsKeys.CreatedAt
        static let UpdatedAt = UdacityParseClient.ResultsKeys.UpdatedAt
    }
    
    typealias ObjectIdType = String
    typealias UniqueKeyType = String
    typealias FirstNameType = String
    typealias LastNameType = String
    typealias MapStringType = String
    typealias MediaURLType = String
    typealias LatitudeType = Float
    typealias LongitudeType = Float
    typealias CreatedAtType = Date
    typealias UpdatedAtType = Date

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
    
    static var formatter = DateFormatter()
    
    static func dateFromString(_ string: String) -> Date? {
        if formatter.dateFormat == "" {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
        return formatter.date(from: string)
    }
    
    init(dictionary: [String:AnyObject?]) {
        
        objectId = dictionary[Keys.ObjectId] as? ObjectIdType
        uniqueKey = dictionary[Keys.UniqueKey] as? UniqueKeyType
        firstName = dictionary[Keys.FirstName] as? FirstNameType
        lastName = dictionary[Keys.LastName] as? LastNameType
        mapString = dictionary[Keys.MapString] as? MapStringType
        mediaURL = dictionary[Keys.MediaURL] as? MediaURLType
        latitude = dictionary[Keys.Latitude] as? LatitudeType
        longitude = dictionary[Keys.Longitude] as? LongitudeType
        createdAt = dictionary[Keys.CreatedAt] != nil ? StudentInformation.dateFromString((dictionary[Keys.CreatedAt] as? String)!) : nil
        updatedAt = dictionary[Keys.UpdatedAt] != nil ? StudentInformation.dateFromString((dictionary[Keys.UpdatedAt] as? String)!) : nil
    }
    
    static func ListFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentInformationList = [StudentInformation]()
        
        // iterate through array of dictionaries, each record is a dictionary
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

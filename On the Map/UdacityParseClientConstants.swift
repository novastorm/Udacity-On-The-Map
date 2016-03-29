//
//  UdacityParseClientConstants.swift
//  On the Map
//
//  Created by Adland Lee on 3/28/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

extension UdacityParseClient {
    
    struct Constants {
        // MARK: API Key
        static let APIKey = "REST API Key"
        
        // MARK: Application Id
        static let ApplicationId = "Parse Application ID"
        
        // MARK: URL information
        static let APIScheme = "https"
        static let APIHost = "api.parse.com"
        static let APIPath = "/1"
        
        static let AuthorizationURL = ""
        
        // MARK: Resources
        struct Resources {

            // MARK: Student Locations
            static let ClassesStudentLocation = "/classes/StudentLocation"
            static let ClassesStudentLocationId = "/classes/StudentLocation/{student_location_id}"
            
            // MARK:
        }
        
        // MARK: URL Keys
        struct URLKeys {
            static let StudentLocationId = "student_location_id"
        }
        
        // MARK: Parameter Keys
        struct ParameterKeys {
        }
        
        struct RequestKeys {
            static let ApplicationIdHeader = "X-Parse-Application-Id"
            static let RESTAPIKey = "X-Parse-REST-API-Key"
        }
        
        // MARK: Response Keys
        struct ResponseKeys {
        }

        // MARK: JSON Request Keys
        struct JSONParameterKeys {
        }
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            static let Results = "results"
            
            static let ObjectId = "objectId"
            typealias ObjectIdType = String
            
            static let UniqueKey = "UniqueKey"
            typealias UniqueKeyType = String
            
            static let FirstName = "firstName"
            typealias FirstNameType = String
            
            static let LastName = "lastName"
            typealias LastNameType = String
            
            static let MapString = "mapString"
            typealias MapStringType = String
            
            static let MediaURL = "mediaURL"
            typealias MediaURLType = String
            
            static let Latitude = "latitude"
            typealias LatitudeType = Float
            
            static let Longitude = "longitude"
            typealias LongitudeType = Float
            
            static let CreatedAt = "createdAt"
            typealias CreatedAtType = String
            
            static let UpdatedAt = "updatedAt"
            typealias UpdatedAtType = String
        }
    }
}
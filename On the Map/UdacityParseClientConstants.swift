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
    }
    
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
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        static let ObjectId = "objectId"
    }
    
    // MARK: Request Keys
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
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"    
    }
}
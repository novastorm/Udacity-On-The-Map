//
//  UdacityClientConstants.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

extension UdacityClient {
    
    // Mark Constants
    struct Constants {
        
        // MARK: API Key
        static let APIKey: String = ""
        
        // MARK: URL information
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
        
        static let AuthorizationURL = ""
    }
    
    // MARK: Resources
    struct Resources {
        
        // MARK: Users
        static let UserId = "/users/{user_id}"
        
        // MARK: Authentication
        static let Session = "/session"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserId = "user_id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
    }
    
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // MARK: General
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionId = "id"
        static let Account = "account"
        static let AccountKey = "key"
        
        // MARK: User
        static let User = "user"
    }
}
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
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        static let FacebookMobile = "facebook_mobile"
        static let AccessToken = "access_token"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {

        // MARK: Authorization
        static let Session = "session"
        static let SessionId = "id"
        static let Account = "account"
        static let AccountKey = "key"
        
        // MARK: User
        static let User = "user"
    }
    
    // MARK: JSON Response Keys
    struct UserKeys {
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Key = "key"
    }
}
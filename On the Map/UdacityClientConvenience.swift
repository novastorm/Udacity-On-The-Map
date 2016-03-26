//
//  UdacityClientConvenience.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import Foundation

// MARK: UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: - Authentication (GET) Methods)
    
    func authenticateWithParameters(inputParameters: [String: AnyObject], completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = inputParameters
        
        // Chain completion handlers for each request to run in sequence
        self.getSession(parameters) { (success, sessionId, accountKey, errorString) in
            if success {
                self.sessionId = sessionId
                self.accountKey = accountKey
            }
            
            completionHandlerForAuth(success: success, errorString: errorString)
        }
    }
    
    private func getSession(inputParameters: [String:AnyObject], completionHandlerForSession: (success: Bool, sessionId: String?, accountKey: String?, errorString: String?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String:AnyObject]()
        let JSONBody = [
            "udacity": [
                JSONBodyKeys.Username: inputParameters[JSONBodyKeys.Username] as! String,
                JSONBodyKeys.Password: inputParameters[JSONBodyKeys.Password] as! String
            ]
        ]
        
        // (2) Make the request
        taskForPOSTMethod(Resources.Session, parameters: parameters, JSONBody: JSONBody) { (results, error) in
            
            // (3) Send to completion handler
            if let error = error {
                print(error)
                completionHandlerForSession(success: false, sessionId: nil, accountKey: nil, errorString: "Login Failed (Session ID)")
                return
            }

            guard let sessionId = results[JSONResponseKeys.Session]??[JSONResponseKeys.SessionId] as? String else {
                print("Could not find \(JSONResponseKeys.Session):\(JSONResponseKeys.SessionId) in \(results)")
                completionHandlerForSession(success: false, sessionId: nil, accountKey: nil, errorString: "Login Failed (Session Id)")
                return
            }
            guard let accountKey = results[JSONResponseKeys.Account]??[JSONResponseKeys.AccountKey] as? String else {
                print("Could not find \(JSONResponseKeys.Account):\(JSONResponseKeys.AccountKey) in \(results)")
                completionHandlerForSession(success: false, sessionId: nil, accountKey: nil, errorString: "Login Failed (Account Key)")
                return
            }
            
            completionHandlerForSession(success: true, sessionId: sessionId, accountKey: accountKey, errorString: nil)
        }
    }
    
    // MARK: - GET Convenience Methods
    
    func getUserById(userId: String, completionHandler: (result: UdacityUser?, error: NSError?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String: AnyObject]()
        
        // (2) Make the request
        taskForGETMethod(Resources.Session, parameters: parameters) { (results, error) in
            
            // (3) Send to completion handler
            if let error = error {
                print(error)
                completionHandler(result: nil, error: error)
            }
            else {
                if let user = results[JSONResponseKeys.User] as? UdacityUser {
                    completionHandler(result: user, error: nil)
                }
                else {
                    print("Could not find \(JSONResponseKeys.User) in \(results)")
                    completionHandler(result: nil, error: error)
                }
            }
        }
    }
    
    // MARK: - POST Convenience Methods
    // MARK: - DELETE Convenience Methods
}
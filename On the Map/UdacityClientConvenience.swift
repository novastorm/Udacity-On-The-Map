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
        self.getSessionId(parameters) { (success, sessionId, errorString) in
            if success {
                self.sessionId = sessionId
                
                self.getUserId{ (success, userId, errorString) in
                    if success {
                        if let userId = userId {
                            self.userId = userId
                        }
                    }
                    
                    completionHandlerForAuth(success: success, errorString: errorString)
                }
            }
            else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
    }
    
    private func getSessionId(inputParameters: [String:AnyObject], completionHandlerForSession: (success: Bool, sessionId: String?, errorString: String?) -> Void) {
        
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
                completionHandlerForSession(success: false, sessionId: nil, errorString: "Login Failed (Session ID)")
            }
            else {
                if let sessionId = results[JSONResponseKeys.SessionId] as? String {
                    completionHandlerForSession(success: true, sessionId: sessionId, errorString: nil)
                }
                else {
                    print("Could not find \(JSONResponseKeys.SessionId) in \(results)")
                    completionHandlerForSession(success: false, sessionId: nil, errorString: "Login Failed (Session ID)")
                }
            }
        }
    }
    
    private func getUserId(completionHandlerForUserId: (success: Bool, userId: String?, errorString: String?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String: AnyObject]()
        
        // (2) Make the request
        taskForGETMethod(Resources.Session, parameters: parameters) { (results, error) in
            
            // (3) Send to completion handler
            if let error = error {
                print(error)
                completionHandlerForUserId(success: false, userId: nil, errorString: "Login Failed (Session ID)")
            }
            else {
                if let userId = results[JSONResponseKeys.UserId] as? String {
                    completionHandlerForUserId(success: true, userId: userId, errorString: nil)
                }
                else {
                    print("Could not find \(JSONResponseKeys.UserId) in \(results)")
                    completionHandlerForUserId(success: false, userId: nil, errorString: "Login Failed (Session ID)")
                }
            }
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
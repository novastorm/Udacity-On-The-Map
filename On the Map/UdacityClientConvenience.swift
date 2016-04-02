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
    
    // MARK: - Authentication Methods
    
    func authenticateWithParameters(inputParameters: [String: AnyObject], completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let parameters = inputParameters
        
        // Chain completion handlers for each request to run in sequence
        self.getSession(parameters) { (success, sessionId, accountKey, error) in
            if success {
                self.sessionId = sessionId
                self.accountKey = accountKey
            }
            
            completionHandlerForAuth(success: success, error: error)
        }
    }
    
    private func getSession(inputParameters: [String:AnyObject], completionHandlerForSession: (success: Bool, sessionId: String?, accountKey: String?, error: NSError?) -> Void) {
        
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
            
            // Custom error function
            func sendError(code: Int, errorString:String) {
                var userInfo = [String: AnyObject]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandlerForSession(success: false, sessionId: nil, accountKey: nil, error: NSError(domain: "getSession", code: code, userInfo: userInfo))
            }
            
            // (3) Send to completion handler
            if let error = error {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }

            guard let sessionId = results[JSONResponseKeys.Session]??[JSONResponseKeys.SessionId] as? String else {
                sendError(1, errorString: "Could not find \(JSONResponseKeys.Session):\(JSONResponseKeys.SessionId) in \(results)")
                return
            }
            guard let accountKey = results[JSONResponseKeys.Account]??[JSONResponseKeys.AccountKey] as? String else {
                sendError(2, errorString: "Could not find \(JSONResponseKeys.Account):\(JSONResponseKeys.AccountKey) in \(results)")
                return
            }
            
            completionHandlerForSession(success: true, sessionId: sessionId, accountKey: accountKey, error: nil)
        }
    }
    
    func logoutSession(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        // (1)
        let parameters = [String: AnyObject]()
        
        // (2)
        taskForDELETEMethod(Resources.Session, parameters: parameters) { (results, error) in
            
            // Custom error function
            func sendError(error:String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(success: false, error: NSError(domain: "logoutSession", code: 1, userInfo: userInfo))
            }
            
            // (3)
            if let error = error {
                sendError("There was an error with the request: \(error)")
                return
            }
            
            guard let _ = results[JSONResponseKeys.Session] else {
                sendError("Could not find \(JSONResponseKeys.Session) in \(results)")
                return
            }

            if results.allKeys.count != 1 {
                sendError("Response contains more than one key in \(results)")
                return
            }
            
            UdacityClient.sharedInstance().clearData()
            completionHandler(success: true, error: nil)
        }
    }
    
    // MARK: - GET Convenience Methods
    
    func getAccountById(userId: String, completionHandler: (result: Account?, error: NSError?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String: AnyObject]()
        
        // (2) Make the request
        taskForGETMethod(Resources.Session, parameters: parameters) { (results, error) in
            
            // (3) Send to completion handler
            if let error = error {
                print(error)
                completionHandler(result: nil, error: error)
                return
            }

            guard let user = results[JSONResponseKeys.User] as? Account else {
                print("Could not find \(JSONResponseKeys.User) in \(results)")
                completionHandler(result: nil, error: error)
                return
            }
            
            completionHandler(result: user, error: nil)
        }
    }
    
    // MARK: - POST Convenience Methods
    // MARK: - DELETE Convenience Methods
}
//
//  UdacityClientConvenience.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import FBSDKLoginKit
import Foundation
import UIKit

// MARK: UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: - Authentication Methods
    
    func authenticateViaUdacity(username username: String, password: String, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let JSONBody = [
            JSONBodyKeys.Udacity: [
                JSONBodyKeys.Username: username,
                JSONBodyKeys.Password: password
            ]
        ]

        
        // Chain completion handlers for each request to run in sequence
        self.getSession(parameters, JSONBody: JSONBody) { (success, sessionId, accountKey, error) in
            if !success {
                completionHandlerForAuth(success: success, error: error)
                return
            }
            
            self.sessionId = sessionId
            self.accountKey = accountKey
            
            self.getAccountById(self.accountKey!) { (success, account, error) in
                if success {
                    self.account = account
                }
                
                completionHandlerForAuth(success: success, error: error)
            }
        }
    }
    
    func authenticateViaFacebook(token: String, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let JSONBody = [
            JSONBodyKeys.FacebookMobile: [
                JSONBodyKeys.AccessToken: token
            ]
        ]
        
        
        // Chain completion handlers for each request to run in sequence
        self.getSession(parameters, JSONBody: JSONBody) { (success, sessionId, accountKey, error) in
            if !success {
                completionHandlerForAuth(success: success, error: error)
                return
            }
            
            self.sessionId = sessionId
            self.accountKey = accountKey
            
            self.getAccountById(self.accountKey!) { (success, account, error) in
                if success {
                    self.account = account
                }
                
                completionHandlerForAuth(success: success, error: error)
            }
        }
    }
    
    private func getSession(inputParameters: [String:AnyObject], JSONBody: [String:AnyObject], completionHandlerForSession: (success: Bool, sessionId: String?, accountKey: String?, error: NSError?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String:AnyObject]()
        
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
            
            UdacityClient.sharedInstance.logout()
            completionHandler(success: true, error: nil)
        }
        FBSDKLoginManager().logOut()
    }
    
    // MARK: - GET Convenience Methods
    
    func getAccountById(userId: String, completionHandler: (success: Bool, account: Account?, error: NSError?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String: AnyObject]()
        
        let resource = subtituteKeyInMethod(Resources.UserId, key: URLKeys.UserId, value: UdacityClient.sharedInstance.accountKey!)!
        
        // (2) Make the request
        taskForGETMethod(resource, parameters: parameters) { (results, error) in
            
            // (3) Send to completion handler
            if let error = error {
                print(error)
                completionHandler(success: false, account: nil, error: error)
                return
            }

            guard let user = results[JSONResponseKeys.User] as? [String: AnyObject] else {
                print("Could not find \(JSONResponseKeys.User) in \(results)")
                completionHandler(success: false, account: nil, error: error)
                return
            }
            
            let account = Account(dictionary: user)
            
            completionHandler(success: true, account: account, error: nil)
        }
    }
}
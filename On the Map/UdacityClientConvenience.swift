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
    
    // MARK: Logout
    
    static func logout (_ completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        sharedInstance.logoutSession { (success, error) in
            if success {
                sharedInstance.accountKey = nil
                sharedInstance.account = nil
            }

            if let completion = completion {
                completion(success, error)
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func authenticateViaUdacity(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let JSONBody = [
            JSONBodyKeys.Udacity: [
                JSONBodyKeys.Username: username,
                JSONBodyKeys.Password: password
            ]
        ]

        
        // Chain completion handlers for each request to run in sequence
        self.getSession(parameters, JSONBody: JSONBody as [String : AnyObject]) { (success, sessionId, accountKey, error) in
            if !success {
                completionHandlerForAuth(success, error)
                return
            }
            
            self.sessionId = sessionId
            self.accountKey = accountKey
            
            self.getAccountById(self.accountKey!) { (success, account, error) in
                if success {
                    self.account = account
                }
                
                completionHandlerForAuth(success, error)
            }
        }
    }
    
    func authenticateViaFacebook(_ token: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let JSONBody = [
            JSONBodyKeys.FacebookMobile: [
                JSONBodyKeys.AccessToken: token
            ]
        ]
        
        
        // Chain completion handlers for each request to run in sequence
        self.getSession(parameters, JSONBody: JSONBody as [String : AnyObject]) { (success, sessionId, accountKey, error) in
            if !success {
                completionHandlerForAuth(success, error)
                return
            }
            
            self.sessionId = sessionId
            self.accountKey = accountKey
            
            self.getAccountById(self.accountKey!) { (success, account, error) in
                if success {
                    self.account = account
                }
                
                completionHandlerForAuth(success, error)
            }
        }
    }
    
    fileprivate func getSession(_ inputParameters: [String:AnyObject], JSONBody: [String:AnyObject], completionHandlerForSession: @escaping (_ success: Bool, _ sessionId: String?, _ accountKey: String?, _ error: NSError?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String:AnyObject]()
        
        // (2) Make the request
        let _ = taskForPOSTMethod(Resources.Session, parameters: parameters, JSONBody: JSONBody) { (results, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandlerForSession(false, nil, nil, NSError(domain: "getSession", code: code, userInfo: userInfo))
            }
            
            // (3) Send to completion handler
            if let error = error {
                if error.code == ErrorCodes.httpUnsucessful.rawValue {
                    completionHandlerForSession(false, nil, nil, NSError(domain: "getSession", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: error.localizedDescription)
                return
            }

            guard let JSONData = results as? [String: AnyObject] else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Bad JSONData in \(results)")
                return
            }
            
            guard let sessionId = JSONData[JSONResponseKeys.Session]?[JSONResponseKeys.SessionId] as? String else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Could not find \(JSONResponseKeys.Session):\(JSONResponseKeys.SessionId) in \(JSONData)")
                return
            }
            guard let accountKey = JSONData[JSONResponseKeys.Account]?[JSONResponseKeys.AccountKey] as? String else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Could not find \(JSONResponseKeys.Account):\(JSONResponseKeys.AccountKey) in \(JSONData)")
                return
            }
            
            completionHandlerForSession(true, sessionId, accountKey, nil)
        }
    }
    
    func logoutSession(_ completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // (1)
        let parameters = [String: AnyObject]()
        
        // (2)
        let _ = taskForDELETEMethod(Resources.Session, parameters: parameters) { (results, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandler(false, NSError(domain: "logoutSession", code: code, userInfo: userInfo))
            }
            
            // (3)
            if let error = error {
                if error.code == ErrorCodes.httpUnsucessful.rawValue {
                    completionHandler(false, NSError(domain: "logoutSession", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: "There was an error with the request.")
                return
            }
            
            guard let JSONData = results as? [String: AnyObject] else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Bad JSONData in \(results)")
                return
            }
            
            guard let _ = JSONData[JSONResponseKeys.Session] else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Could not find \(JSONResponseKeys.Session) in \(JSONData)")
                return
            }

            if JSONData.keys.count != 1 {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Response contains more than one key in \(JSONData)")
                return
            }
            
            completionHandler(true, nil)
        }
        FBSDKLoginManager().logOut()
    }
    
    // MARK: - GET Convenience Methods
    
    func getAccountById(_ userId: String, completionHandler: @escaping (_ success: Bool, _ account: Account?, _ error: NSError?) -> Void) {
        
        // (1) Specify parameters
        let parameters = [String: AnyObject]()
        
        let resource = subtituteKeyInMethod(Resources.UserId, key: URLKeys.UserId, value: UdacityClient.sharedInstance.accountKey!)!
        
        // (2) Make the request
        let _ = taskForGETMethod(resource, parameters: parameters) { (results, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandler(false, nil, NSError(domain: "getAccountById", code: code, userInfo: userInfo))
            }
            
            // (3) Send to completion handler
            if let error = error {
                if error.code == ErrorCodes.httpUnsucessful.rawValue {
                    completionHandler(false, nil, NSError(domain: "logoutSession", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            guard let JSONData = results as? [String: AnyObject] else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Bad JSONData in \(results)")
                return
            }

            guard let user = JSONData[JSONResponseKeys.User] as? [String: AnyObject] else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Could not find \(JSONResponseKeys.User) in \(JSONData)")
                return
            }
            
            let account = Account(dictionary: user)
            
            completionHandler(true, account, nil)
        }
    }
}

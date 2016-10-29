//
//  UdacityParseClientConvenience.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityParseClient (Convenient Resource Methods)

extension UdacityParseClient {

    // MARK: - GET Convenience Methods
    func getStudentInformationList(_ completionHandler: @escaping (_ studentInformationList: [StudentInformation]?, _ error: NSError?) -> Void) {
        
        // (1)
        let parameters: [String: AnyObject] = [
            ParameterKeys.Limit: ParameterValues.Limit as AnyObject,
            ParameterKeys.Order: ParameterValues.UpdatedAtDescending as AnyObject
        ]
        
        // (2)
        let _ = taskForGETMethod(Resources.ClassesStudentLocation, parameters: parameters) { (data, error) in
            
            // error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandler(nil, NSError(domain: "getStudentInformationList", code: code, userInfo: userInfo))
            }
            
            // (3)
            if let error = error {
                if error.code == ErrorCodes.httpUnsucessful.rawValue {
                    completionHandler(nil, NSError(domain: "getStudentInformationList", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            let data = data as! [String: AnyObject]
            
            guard let responseResults = data[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError(ErrorCodes.dataError.rawValue, errorString: "Could not find \(JSONResponseKeys.Results) in \(data)")
                return
            }

            var studentInformationList = [StudentInformation]()
            
            for record in responseResults {
                studentInformationList.append(StudentInformation(dictionary: record))
            }
            
            StudentInformation.list = studentInformationList
            completionHandler(studentInformationList, nil)
        }
    }
    
    // MARK: - POST Convenience Methods
    
    func storeStudentInformation(_ student: StudentInformation, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // 1
        let parameters = [String:AnyObject]()
        let JSONBody: [String:AnyObject] = [
            JSONParameterKeys.UniqueKey: student.uniqueKey! as AnyObject,
            JSONParameterKeys.FirstName: student.firstName! as AnyObject,
            JSONParameterKeys.LastName: student.lastName! as AnyObject,
            JSONParameterKeys.MapString: student.mapString! as AnyObject,
            JSONParameterKeys.MediaURL: student.mediaURL! as AnyObject,
            JSONParameterKeys.Latitude: student.latitude! as AnyObject,
            JSONParameterKeys.Longitude: student.longitude! as AnyObject
        ]
        
        // 2
        let _ = taskForPOSTMethod(Resources.ClassesStudentLocation, parameters: parameters, JSONBody: JSONBody) { (results, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandler(false, NSError(domain: "storeStudentInformation", code: code, userInfo: userInfo))
            }
            
            // (3) Send to completion handler
            if let error = error {
                if error.code == ErrorCodes.httpUnsucessful.rawValue {
                    completionHandler(false, NSError(domain: "storeStudentInformation", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: error.localizedDescription)
                return
            }

            completionHandler(true, nil)
        }
    }
    
    // MARK: - DELETE Convenience Methods
}

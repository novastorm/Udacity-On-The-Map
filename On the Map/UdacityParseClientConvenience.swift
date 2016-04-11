//
//  UdacityParseClientConvenience.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import Foundation

// MARK: Notification Identifiers

let StudentInformationUpdatedNotification = "StudentInformationUpdatedNotification"

// MARK: - UdacityParseClient (Convenient Resource Methods)

extension UdacityParseClient {

    // MARK: - GET Convenience Methods
    func getStudentInformationList(completionHandler: (studentInformationList: [StudentInformation]?, error: NSError?) -> Void) {
        
        // (1)
        let parameters: [String: AnyObject] = [
            ParameterKeys.Limit: ParameterValues.Limit,
            ParameterKeys.Order: ParameterValues.UpdatedAtDescending
        ]
        
        // (2)
        taskForGETMethod(Resources.ClassesStudentLocation, parameters: parameters) { (data, error) in
            
            // error function
            func sendError(code: Int, errorString:String) {
                var userInfo = [String: AnyObject]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandler(studentInformationList: nil, error: NSError(domain: "getStudentInformationList", code: code, userInfo: userInfo))
            }
            
            // (3)
            if let error = error {
                if error.code == ErrorCodes.HTTPUnsucessful.rawValue {
                    completionHandler(studentInformationList: nil, error:
                        NSError(domain: "getStudentInformationList", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            guard let responseResults = data[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError(ErrorCodes.DataError.rawValue, errorString: "Could not find \(JSONResponseKeys.Results) in \(data)")
                return
            }

            var studentInformationList = [StudentInformation]()
            
            for record in responseResults {
                studentInformationList.append(StudentInformation(dictionary: record))
            }
            
            StudentInformation.list = studentInformationList
            NSNotificationCenter.defaultCenter().postNotificationName(StudentInformationUpdatedNotification, object: nil)
            completionHandler(studentInformationList: studentInformationList, error: nil)
        }
    }
    
    // MARK: - POST Convenience Methods
    
    func storeStudentInformation(student: StudentInformation, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        // 1
        let parameters = [String:AnyObject]()
        let JSONBody: [String:AnyObject] = [
            JSONParameterKeys.UniqueKey: student.uniqueKey!,
            JSONParameterKeys.FirstName: student.firstName!,
            JSONParameterKeys.LastName: student.lastName!,
            JSONParameterKeys.MapString: student.mapString!,
            JSONParameterKeys.MediaURL: student.mediaURL!,
            JSONParameterKeys.Latitude: student.latitude!,
            JSONParameterKeys.Longitude: student.longitude!
        ]
        
        // 2
        taskForPOSTMethod(Resources.ClassesStudentLocation, parameters: parameters, JSONBody: JSONBody) { (results, error) in
            
            // Custom error function
            func sendError(code: Int, errorString:String) {
                var userInfo = [String: AnyObject]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                
                completionHandler(success: false, error: NSError(domain: "storeStudentInformation", code: code, userInfo: userInfo))
            }
            
            // (3) Send to completion handler
            if let error = error {
                if error.code == ErrorCodes.HTTPUnsucessful.rawValue {
                    completionHandler(success: false, error: NSError(domain: "storeStudentInformation", code: error.code, userInfo: error.userInfo))
                }
                sendError(error.code, errorString: error.localizedDescription)
                return
            }

            completionHandler(success: true, error: nil)
        }
    }
    
    // MARK: - DELETE Convenience Methods
}
//
//  UdacityParseClientConvenience.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import Foundation

// MARK: UdacityParseClient (Convenient Resource Methods)

extension UdacityParseClient {

    // MARK: - GET Convenience Methods
    func getStudentInformationList(completionHandler: (studentInformationList: [StudentInformation]?, error: NSError?) -> Void) {
        
        // (1)
        let parameters = [
            ParameterKeys.Limit: 100,
            ParameterKeys.Order: "-updatedAt"
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
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            guard let responseResults = data[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError(1, errorString: "Could not find \(JSONResponseKeys.Results) in \(data)")
                return
            }

            var studentInformationList = [StudentInformation]()
            
            for record in responseResults {
                studentInformationList.append(StudentInformation(dictionary: record))
            }
            
            self.studentInformationList = studentInformationList
            
            completionHandler(studentInformationList: studentInformationList, error: nil)
        }
    }
    
    // MARK: - POST Convenience Methods
    // MARK: - DELETE Convenience Methods
}
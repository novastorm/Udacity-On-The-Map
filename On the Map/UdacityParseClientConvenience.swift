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

    func getStudentLocationList(completionHandler: (studentLocations: [StudentLocation]?, error: NSError?) -> Void) {
        
        // (1)
        let parameters = [
            ParameterKeys.Limit: 100,
            ParameterKeys.Order: "updatedAt"
        ]
        
        // (2)
        taskForGETMethod(Resources.ClassesStudentLocation, parameters: parameters) { (data, error) in
            
            // error function
            func sendError(errorString: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: errorString]
                completionHandler(studentLocations: nil, error: NSError(domain: "getStudentLocationList", code: 1, userInfo: userInfo))
            }
            
            // (3)
            if let error = error {
                sendError("There was an error with the request \(error)")
                return
            }
            
            guard let results = data[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError("Could not find \(JSONResponseKeys.Results) in \(data)")
                return
            }

            var studentLocationList = [StudentLocation]()
            
            for result in results {
                studentLocationList.append(StudentLocation(dictionary: result))
            }
            
            completionHandler(studentLocations: studentLocationList, error: nil)
        }
    }
    
    // MARK: - POST Convenience Methods
    // MARK: - DELETE Convenience Methods
}
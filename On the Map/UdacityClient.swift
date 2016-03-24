//
//  UdacityClient.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // MARK: Properties
    var session = NSURLSession.sharedSession()
    
    // Configuration object
    var config = UdacityConfig()
    
    // authentication state
    var sessionId: String? = nil
    var userId: Int? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
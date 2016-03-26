//
//  UdacityClientReachability.swift
//  On the Map
//
//  Created by Adland Lee on 3/25/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation
import Reachability
import UIKit

extension UdacityClient {
    
    func checkNetworkConnection(viewController: UIViewController, completionHandler: (success: Bool, error: String?) -> Void) {

        var reachability: Reachability?
        
        do {
            reachability = try Reachability(hostname: Constants.APIHost)
        }
        catch {
            print("Cannot create Reachability")
        }
        
        if let reachable = reachability?.isReachable() where reachable{
            completionHandler(success: true, error: nil)
        }
        else {
            completionHandler(success: false, error: "Network unreachable")
        }
        
    }
}
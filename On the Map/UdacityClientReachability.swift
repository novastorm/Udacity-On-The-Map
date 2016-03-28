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
        
        guard let reachable = reachability?.isReachable() where reachable else {
            // Debug without network
            if (UIApplication.sharedApplication().delegate as! AppDelegate).debugWithoutNetwork {
                completionHandler(success: true, error: nil)
                return
            }
            
            completionHandler(success: false, error: "Network unreachable")
            return
        }
        
        completionHandler(success: true, error: nil)
    }
}
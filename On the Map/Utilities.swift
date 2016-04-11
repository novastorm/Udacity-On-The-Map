//
//  Utilities.swift
//  On the Map
//
//  Created by Adland Lee on 3/29/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation
import Reachability
import UIKit


func showAlert(vc: UIViewController, title: String?, message: String?) {
    performUIUpdatesOnMain { 
    
        // display alert
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
        ac.addAction(okAction)
        
        // workaround for this error:
        // Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
        ac.view.layoutIfNeeded()
        // ***
        vc.presentViewController(ac, animated: true, completion: nil)
    }
}

func showNetworkAlert(vc: UIViewController) {
    let NetworkErrorTitle = "Network unreachable."
    let NetworkErrorMessage = "Check network connection"
    
    showAlert(vc, title: NetworkErrorTitle, message: NetworkErrorMessage)
}

func checkNetworkConnection(hostname: String?, completionHandler: (success: Bool, error: NSError?) -> Void) {
    
    var reachability: Reachability?
    
    do {
        reachability = try hostname == nil ? Reachability.reachabilityForInternetConnection() : Reachability(hostname: hostname!)
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
        
        let userInfo: [String:AnyObject] = [
            NSLocalizedDescriptionKey: "Network not reachable"
        ]
        
        completionHandler(success: false, error: NSError(domain: "checkNetworkConnection", code: 1, userInfo: userInfo))
        return
    }
    
    completionHandler(success: true, error: nil)
}

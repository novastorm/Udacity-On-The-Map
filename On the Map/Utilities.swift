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

let NetworkError = "Network unreachable. Check network connection."
let NetworkErrorTitle = "Network unreachable."
let NetworkErrorMessage = "Check network connection"


func showAlert(vc: UIViewController, title: String?, message: String?) {
    performUIUpdatesOnMain { 
    
        // display alert
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
        ac.addAction(okAction)
        
        vc.presentViewController(ac, animated: true, completion: nil)
    }
}

func showNetworkAlert(vc: UIViewController) {
    showAlert(vc, title: NetworkErrorTitle, message: NetworkErrorMessage)
}

func checkNetworkConnection(hostname: String?, completionHandler: (success: Bool, error: String?) -> Void) {
    
    var reachability: Reachability?
    
    do {
        reachability = try hostname == nil ? Reachability.reachabilityForInternetConnection() : Reachability(hostname: hostname!)
    }
    catch {
        print("Cannot create Reachability")
    }
    
//    print("reachability status: \(reachability?.currentReachabilityStatus)")
//    print("reachable: \(reachability?.isReachable())")
    
    guard let reachable = reachability?.isReachable() where reachable else {
        // Debug without network
        if (UIApplication.sharedApplication().delegate as! AppDelegate).debugWithoutNetwork {
            completionHandler(success: true, error: nil)
            return
        }
        
        completionHandler(success: false, error: NetworkError)
        return
    }
    
    completionHandler(success: true, error: nil)
}

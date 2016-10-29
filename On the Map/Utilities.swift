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


func showAlert(_ vc: UIViewController, title: String?, message: String?) {
    performUIUpdatesOnMain { 
    
        // display alert
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        ac.addAction(okAction)
        
        // workaround for this error:
        // Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
        ac.view.layoutIfNeeded()
        // ***
        vc.present(ac, animated: true, completion: nil)
    }
}

func showNetworkAlert(_ vc: UIViewController) {
    let NetworkErrorTitle = "Network unreachable."
    let NetworkErrorMessage = "Check network connection"
    
    showAlert(vc, title: NetworkErrorTitle, message: NetworkErrorMessage)
}

func checkNetworkConnection(_ hostname: String?, completionHandler: (_ success: Bool, _ error: NSError?) -> Void) {
    
    var reachability: Reachability?
    
    reachability = (hostname == nil) ? Reachability() : Reachability(hostname: hostname!)
    
    guard let reachable = reachability?.isReachable , reachable else {
        // Debug without network
        if (UIApplication.shared.delegate as! AppDelegate).debugWithoutNetwork {
            completionHandler(true, nil)
            return
        }
        
        let userInfo: [String:AnyObject] = [
            NSLocalizedDescriptionKey: "Network not reachable" as AnyObject
        ]
        
        completionHandler(false, NSError(domain: "checkNetworkConnection", code: 1, userInfo: userInfo))
        return
    }
    
    completionHandler(true, nil)
}

func distanceInMeters(kilometers: Double) -> Double {
    return kilometers * 1000
}

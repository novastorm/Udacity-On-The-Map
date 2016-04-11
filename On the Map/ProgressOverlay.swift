//
//  ProgressOverlay.swift
//  On the Map
//
//  Created by Adland Lee on 4/9/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class ProgressOverlay {
    
    // MARK: Properties
    
    static let sharedInstance = ProgressOverlay()
    var presentingVC: UIViewController?
    
    let alertView = UIAlertController()
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50))
    
    // MARK: Initializers
    
    // This is a Singleton, make initializer private
    private init() {
        alertView.view.tintColor = UIColor.blackColor()
        alertView.view.addSubview(activityIndicator)

        activityIndicator.activityIndicatorViewStyle = .Gray
    }
    
    
    static func start(vc: UIViewController, title: String? = nil, message: String? = nil, completion: (() -> Void)?) {
        sharedInstance.presentingVC = vc
        sharedInstance.alertView.view.layoutIfNeeded()
        
        sharedInstance.alertView.title = title
        sharedInstance.alertView.message = message
        
        sharedInstance.activityIndicator.startAnimating()
        sharedInstance.presentingVC!.presentViewController(sharedInstance.alertView, animated: true, completion: completion)
    }
    
    static func stop(completion: (() -> Void)?) {
        sharedInstance.activityIndicator.stopAnimating()
        sharedInstance.alertView.dismissViewControllerAnimated(true, completion: completion)
        sharedInstance.presentingVC = nil
    }

}
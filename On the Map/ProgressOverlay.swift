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
    var presentingVC: UIViewController!
    
    let alertView = UIAlertController()
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50))
    
    // MARK: Initializers
    
    // This is a Singleton, make initializer private
    private init() {
        alertView.view.tintColor = UIColor.blackColor()
        alertView.view.addSubview(activityIndicator)

        activityIndicator.activityIndicatorViewStyle = .Gray
    }
    
    
    func start(vc: UIViewController, title: String? = nil, message: String? = nil) {
        presentingVC = vc
        alertView.view.layoutIfNeeded()
        
        alertView.title = title
        alertView.message = message
        
        activityIndicator.startAnimating()
        presentingVC.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func stop() {
        activityIndicator.stopAnimating()
        alertView.dismissViewControllerAnimated(true, completion: nil)
        presentingVC = nil
    }

}
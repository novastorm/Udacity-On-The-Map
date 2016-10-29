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
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    // MARK: Initializers
    
    // This is a Singleton, make initializer private
    fileprivate init() {
        alertView.view.tintColor = UIColor.black
        alertView.view.addSubview(activityIndicator)

        activityIndicator.activityIndicatorViewStyle = .gray
    }
    
    
    static func start(_ vc: UIViewController, title: String? = nil, message: String? = nil, completion: (() -> Void)?) {
        sharedInstance.presentingVC = vc
        sharedInstance.alertView.view.layoutIfNeeded()
        
        sharedInstance.alertView.title = title
        sharedInstance.alertView.message = message
        
        sharedInstance.activityIndicator.startAnimating()
        sharedInstance.presentingVC!.present(sharedInstance.alertView, animated: true, completion: completion)
    }
    
    static func stop(_ completion: (() -> Void)?) {
        sharedInstance.activityIndicator.stopAnimating()
        sharedInstance.alertView.dismiss(animated: true, completion: completion)
        sharedInstance.presentingVC = nil
    }

}

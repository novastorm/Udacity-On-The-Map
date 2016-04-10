//
//  StudentTabBarController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class StudentTabBarController: UITabBarController {
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance.logoutSession { (success, error) in
            if success {
                UdacityParseClient.sharedInstance().studentInformationList.removeAll()
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true) {}
                }
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        UdacityParseClient.sharedInstance().getStudentInformationList { (studentInformationList, error) in
            
            if let error = error {
                if error.code == NSURLErrorNotConnectedToInternet {
                    showAlert(self, title: nil, message: error.localizedDescription)
                    return
                }
                if error.code == NSURLErrorTimedOut {
                    showAlert(self, title: nil, message: error.localizedDescription)
                    return
                }
            }
        }
    }
}

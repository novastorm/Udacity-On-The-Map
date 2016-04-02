//
//  MapTabBarController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class MapTabBarController: UITabBarController {
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logoutSession { (success, error) in
            if success {
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true) {}
                }
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        print("refresh")
        UdacityParseClient.sharedInstance().getStudentInformationList { (studentInformationList, error) in
            
            guard let studentInformationList = studentInformationList else {
                print(error)
                return
            }
            
            print(studentInformationList)
        }
    }
    
    @IBAction func showInformationDetail(sender: AnyObject) {
        print("showInformationDetail")
    }
}

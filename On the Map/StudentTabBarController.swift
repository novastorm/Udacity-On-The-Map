//
//  StudentTabBarController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

// MARK: StudentTabBarController: UITabBarController

class StudentTabBarController: UITabBarController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        refreshStudentInformationList()
    }
    
    // MARK: Actions
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance.logoutSession { (success, error) in
            if success {
                UdacityParseClient.sharedInstance.studentInformationList.removeAll()
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true) {}
                }
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        refreshStudentInformationList()
    }
    
    func refreshStudentInformationList() {
        ProgressOverlay.start(self, message: "Retrieving data ...") {
            UdacityParseClient.sharedInstance.getStudentInformationList { (studentInformationList, error) in
                performUIUpdatesOnMain() {
                    ProgressOverlay.stop() {
                        if let error = error {
                            if error.code == ErrorCodes.HTTPUnsucessful.rawValue {
                                let response = error.userInfo["http_response"] as! NSHTTPURLResponse
                                if response.statusCode == 401 {
                                    showAlert(self, title:"Unauthorized", message: "Cannot access resource.")
                                }
                            }
                            else {
                                showAlert(self, title: nil, message: error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
}

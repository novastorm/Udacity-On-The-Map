//
//  StudentTabBarController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

// MARK: Notification Identifiers

let RefreshStudentInformationListNotification = "RefreshStudentInformationListNotification"

// MARK: StudentTabBarController: UITabBarController

class StudentTabBarController: UITabBarController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshStudentInformationList), name: NSNotification.Name(rawValue: RefreshStudentInformationListNotification), object: nil)
        refreshStudentInformationList()
    }
    
    // MARK: Actions
    
    @IBAction func logout(_ sender: AnyObject) {
        UdacityClient.logout() { (success, error) in
            if success {
                StudentInformation.list.removeAll()
                performUIUpdatesOnMain{
                    self.dismiss(animated: true) {}
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        refreshStudentInformationList()
    }
    
    
    // MARK: Helper Utilities
    
    func refreshStudentInformationList() {
        ProgressOverlay.start(self, message: "Retrieving data ...") {
            UdacityParseClient.sharedInstance.getStudentInformationList { (studentInformationList, error) in
                performUIUpdatesOnMain() {
                    ProgressOverlay.stop() {
                        if let error = error {
                            if error.code == ErrorCodes.httpUnsucessful.rawValue {
                                let response = error.userInfo["http_response"] as! HTTPURLResponse
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
    
    
    // MARK: Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

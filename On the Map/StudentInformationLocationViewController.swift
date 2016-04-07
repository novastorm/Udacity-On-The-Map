//
//  StudentInformationLocationViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation
import UIKit

class StudentInformationLocationViewController: UIViewController {
    
    var account: Account!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        print("findOnTheMap")
        print("location \(locationTextField.text)")

        guard let storyboard = storyboard else {
            print("Unable to get storyboard")
            return
        }
        
        guard let destinationVC = storyboard.instantiateViewControllerWithIdentifier("StudentInformationURLViewController") as? StudentInformationURLViewController else {
            print("View not found")
            return
        }
        
        guard let presentingVC = self.presentingViewController else {
            print("Unable to get presenting view controller")
            return
        }

        dismissViewControllerAnimated(false) {
            presentingVC.presentViewController(destinationVC, animated: true) {}
        }
    }
}

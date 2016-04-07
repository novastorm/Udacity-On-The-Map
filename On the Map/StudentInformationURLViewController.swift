//
//  StudentInformationURLViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation
import UIKit

class StudentInformationURLViewController: UIViewController {
    
    var account: Account!
    
    @IBOutlet weak var URLTextField: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        print("StudentInformationURLViewController::cancel")
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func submit(sender: AnyObject) {
        print("StudentInformationURLViewController::submit")
        print("URI: \(URLTextField.text)")
    }
}
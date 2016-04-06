//
//  StudentInformationPosting1ViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation
import UIKit

class StudentInformationPosting1ViewController: UIViewController {
    
    var account: Account!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        print("findOnTheMap")
        print("location \(locationTextField.text)")
    }
}
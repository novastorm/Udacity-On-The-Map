//
//  StudentDetailViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation
import UIKit

class StudentDetailViewController: UIViewController {
    
    var student: StudentInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(student)
    }

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
//
//  StudentInformationLocationViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

class StudentInformationLocationViewController: UIViewController {
    
    var geocoder: CLGeocoder?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        print("findOnTheMap")
        print("location \(locationTextField.text)")

        guard let addressString = locationTextField.text else {
            showAlert(self, title: nil, message: "Unable to unwrap location string")
            return
        }
        
        if geocoder == nil {
            geocoder = CLGeocoder()
        }

        guard let geocoder = geocoder else {
            showAlert(self, title: "Error", message: "Error unwrapping geocoder object")
            return
        }
        
        geocoder.cancelGeocode()
        geocoder.geocodeAddressString(addressString, completionHandler: { (placemarks, error) in
            if error != nil {
                showAlert(self, title: "Error", message: "\(error)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                showAlert(self, title: nil, message: "Unable to get first plackmark")
                return
            }
            
            self.showStudentInformationURLView(placemark)
        })
    }
    
    func showStudentInformationURLView(placemark: CLPlacemark) {
        guard let storyboard = storyboard else {
            print("Unable to get storyboard")
            return
        }
        
        guard let presentingVC = self.presentingViewController else {
            print("Unable to get presenting view controller")
            return
        }
        
        guard let destinationVC = storyboard.instantiateViewControllerWithIdentifier("StudentInformationURLViewController") as? StudentInformationURLViewController else {
            print("View not found")
            return
        }
        
        destinationVC.placemark = placemark
        
        dismissViewControllerAnimated(false) {
            presentingVC.presentViewController(destinationVC, animated: true) {}
        }
    }
}

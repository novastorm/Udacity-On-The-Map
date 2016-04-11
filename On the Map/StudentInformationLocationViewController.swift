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

// MARK: StudentInformationLocationViewController: UIViewController

class StudentInformationLocationViewController: UIViewController {
    
    // MARK: Properties
    
    var geocoder = CLGeocoder()
    
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    // MARK: Actions
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        guard let addressString = locationTextField.text else {
            showAlert(self, title: nil, message: "Unable to unwrap location string")
            return
        }
        
        if addressString.isEmpty {
            setTextFieldBorderToDanger(locationTextField)
            showAlert(self, title: "Enter a location", message: "A location is needed to display where you are at the moment.")
            return
        }
        
        geocoder.cancelGeocode()
        ProgressOverlay.start(self, message: "Getting location ...") {
            self.geocoder.geocodeAddressString(addressString) { (placemarks, error) in
                performUIUpdatesOnMain() {
                    ProgressOverlay.stop() {
                        if let error = error {
                            if error.code == CLError.Network.rawValue {
                                showNetworkAlert(self)
                            }
                            else if error.code == CLError.GeocodeFoundNoResult.rawValue {
                                showAlert(self, title: "No Location Found", message: "Check location and try again.")
                            }
                            else {
                                showAlert(self, title: "Error Getting Location", message: error.localizedDescription)
                            }
                            return
                        }
                        
                        guard let placemark = placemarks?.first else {
                            showAlert(self, title: nil, message: "Unable to get first plackmark")
                            return
                        }
                        
                        self.showStudentInformationURLView(placemark)
                    }
                }
            }
        }
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: Helper Utilities

    func setTextFieldBorderToDanger(textField: UITextField) {
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    func setTextFieldBorderToDefault(textField: UITextField) {
        textField.layer.borderColor = nil
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5.0
    }

    func showStudentInformationURLView(placemark: CLPlacemark) {
        let presentingVC = self.presentingViewController!
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("StudentInformationURLViewController") as! StudentInformationURLViewController
        destinationVC.placemark = placemark
        
        dismissViewControllerAnimated(false) {
            presentingVC.presentViewController(destinationVC, animated: true) {}
        }
    }
}


// MARK: - StudentInformationLocationViewController: UITextFieldDelegate
extension StudentInformationLocationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        setTextFieldBorderToDefault(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

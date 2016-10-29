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
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true) {}
    }
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
        
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
                        if let error = error as? NSError {
                            if error.code == CLError.Code.network.rawValue {
                                showNetworkAlert(self)
                            }
                            else if error.code == CLError.Code.geocodeFoundNoResult.rawValue {
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
    
    @IBAction func userTappedBackground(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: Helper Utilities

    func setTextFieldBorderToDanger(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    func setTextFieldBorderToDefault(_ textField: UITextField) {
        textField.layer.borderColor = nil
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5.0
    }

    func showStudentInformationURLView(_ placemark: CLPlacemark) {
        let presentingVC = self.presentingViewController!
        let destinationVC = storyboard!.instantiateViewController(withIdentifier: "StudentInformationURLViewController") as! StudentInformationURLViewController
        destinationVC.placemark = placemark
        
        dismiss(animated: false) {
            presentingVC.present(destinationVC, animated: true) {}
        }
    }
}


// MARK: - StudentInformationLocationViewController: UITextFieldDelegate
extension StudentInformationLocationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderToDefault(textField)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        findOnTheMap(self)
        return true
    }
}

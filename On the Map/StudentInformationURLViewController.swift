//
//  StudentInformationURLViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

// MARK: StudentInformationURLViewController: UIViewController

class StudentInformationURLViewController: UIViewController {
    
    // MARK: Properties
    
    var placemark: CLPlacemark!
    var regionRadiusKm = 10.0
    
    var account: Account? {
        return UdacityClient.sharedInstance.account
    }

    
    // MARK: Outlets
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {

        URLTextField.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = (placemark.location?.coordinate)!
        mapView.addAnnotation(annotation)
        
        let radius = distanceInMeters(kilometers: regionRadiusKm)

        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, radius, radius)
        mapView.setRegion(region, animated: false)
    }
    
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true) {}
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        guard let url = URLTextField.text else {
            showAlert(self, title: nil, message: "Unable to unwrap location string")
            return
        }
        
        if url.isEmpty {
            setTextFieldBorderToDanger(URLTextField)
            showAlert(self, title: "Enter a location", message: "A location is needed to display where you are at the moment.")
            return
        }

        
        let studentInformation = StudentInformation(dictionary: [
            StudentInformation.Keys.UniqueKey: account!.key! as Optional<AnyObject>,
            StudentInformation.Keys.FirstName: account!.firstName! as Optional<AnyObject>,
            StudentInformation.Keys.LastName: account!.lastName! as Optional<AnyObject>,
            StudentInformation.Keys.MapString: placemark.name! as Optional<AnyObject>,
            StudentInformation.Keys.MediaURL: url as Optional<AnyObject>,
            StudentInformation.Keys.Latitude: (placemark.location?.coordinate.latitude)! as Optional<AnyObject>,
            StudentInformation.Keys.Longitude: (placemark.location?.coordinate.longitude)! as Optional<AnyObject>
        ])
        
        ProgressOverlay.start(self, message: "Uploading Information ...") {
            UdacityParseClient.sharedInstance.storeStudentInformation(studentInformation) { (success, error) in
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
                            return
                        }

                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: RefreshStudentInformationListNotification), object: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func userTappedBackground(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: Help Utilities
    
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
}


// MARK: - StudentInformationURLViewController: UITextFieldDelegate

extension StudentInformationURLViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderToDefault(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        submit(self)
        return true
    }
    
}

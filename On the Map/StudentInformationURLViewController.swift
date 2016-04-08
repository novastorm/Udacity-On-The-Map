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

class StudentInformationURLViewController: UIViewController {
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    var placemark: CLPlacemark!
    
    var account: Account? {
        return UdacityClient.sharedInstance().account
    }
    
    override func viewDidLoad() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = (placemark.location?.coordinate)!
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func submit(sender: AnyObject) {
        let studentInformation = StudentInformation(dictionary: [
            StudentInformation.Keys.UniqueKey: account!.key!,
            StudentInformation.Keys.FirstName: account!.firstName!,
            StudentInformation.Keys.LastName: account!.lastName!,
            StudentInformation.Keys.MapString: placemark.name!,
            StudentInformation.Keys.MediaURL: URLTextField.text!,
            StudentInformation.Keys.Latitude: (placemark.location?.coordinate.latitude)!,
            StudentInformation.Keys.Longitude: (placemark.location?.coordinate.longitude)!
        ])
        
        UdacityParseClient.sharedInstance().storeStudentInformation(studentInformation) { (success, error) in
            if let error = error {
                showAlert(self, title: nil, message: error.localizedDescription)
                return
            }
            
            UdacityParseClient.sharedInstance().getStudentInformationList() { (studentInformationList, error) in
                return
            }

            self.dismissViewControllerAnimated(true) {}
        }
    }
}
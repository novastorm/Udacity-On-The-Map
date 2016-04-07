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
//        print(placemark)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = (placemark.location?.coordinate)!
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        print("StudentInformationURLViewController::cancel")
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func submit(sender: AnyObject) {
        print("StudentInformationURLViewController::submit")
        print("URI: \(URLTextField.text)")
    }
}
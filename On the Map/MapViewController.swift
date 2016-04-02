//
//  MapViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentInformationList: [StudentInformation] {
        return UdacityParseClient.sharedInstance().studentInformationList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivity()
        
        UdacityParseClient.sharedInstance().getStudentInformationList { (studentInformationList, error) in
            
            guard let studentInformationList = studentInformationList else {
                print(error)
                return
            }
            
            print(studentInformationList)
            performUIUpdatesOnMain{
                self.stopActivity()
            }
        }
    }
    
    func startActivity() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        activityIndicator.alpha = 0
        activityIndicator.stopAnimating()
    }
}
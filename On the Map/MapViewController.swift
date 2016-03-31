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
    
    var studentLocationList = [StudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivity()
        
        UdacityParseClient.sharedInstance().getStudentLocationList { (studentLocations, error) in
            
            guard let studentLocationList = studentLocations else {
                print(error)
                return
            }
            
            print(studentLocationList)
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
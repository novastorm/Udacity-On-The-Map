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
    
    var studentLocationList = [UdacityParseStudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UdacityParseClient.sharedInstance().getStudentLocationList { (studentLocations, error) in
            
            guard let studentLocationList = studentLocations else {
                print(error)
                return
            }
            
            print(studentLocationList)
        }
    }
}
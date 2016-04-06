//
//  StudentMapViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentInformationList: [StudentInformation] {
        return UdacityParseClient.sharedInstance().studentInformationList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivity()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateLocations), name: StudentInformationUpdatedNotification, object: nil)
        
        UdacityParseClient.sharedInstance().getStudentInformationList { (studentInformationList, error) in
            
            performUIUpdatesOnMain{
                self.stopActivity()
            }
        }
    }
    
    func updateLocations() {

        var annotations = [MKPointAnnotation]()

        for student in studentInformationList {
            let lat = CLLocationDegrees(student.latitude!)
            let lon = CLLocationDegrees(student.longitude!)
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let first = student.firstName!
            let last = student.lastName!
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }

        performUIUpdatesOnMain {
            
            // mapView updates need to happen on main queue
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension StudentMapViewController: MKMapViewDelegate {
    
    // add info icon to annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let components = NSURLComponents(string: (view.annotation?.subtitle)!!) else {
            showAlert(self, title: nil, message: "Invalid URL components")
            return
        }

        components.scheme = components.scheme ?? "http"

        guard let url = components.URL else {
            showAlert(self, title: nil, message: "Invalid URL")
            return
        }

        guard UIApplication.sharedApplication().openURL(url) else {
            showAlert(self, title: "Cannot open URL", message: "\(url)")
            return
        }
    }
}
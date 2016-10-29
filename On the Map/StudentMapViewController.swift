//
//  StudentMapViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import MapKit

// MARK: StudentMapViewController: UIViewController

class StudentMapViewController: UIViewController {
    
    // MARK: Properties
    
    var studentInformationList: [StudentInformation] {
        return StudentInformation.list
    }

    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocations), name: .studentInformationUpdated, object: nil)
    }
    
    
    // MARK: Helper Utilities
    
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
    
    
    // MARK: Deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - StudentMapViewController: MKMapViewDelegate

extension StudentMapViewController: MKMapViewDelegate {
    
    // add info icon to annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard var components = URLComponents(string: (view.annotation?.subtitle)!!) else {
            showAlert(self, title: nil, message: "Invalid URL components")
            return
        }

        components.scheme = components.scheme ?? "http"

        guard let url = components.url else {
            showAlert(self, title: nil, message: "Invalid URL")
            return
        }

        guard UIApplication.shared.canOpenURL(url) else {
            showAlert(self, title: "Cannot open URL", message: "\(url)")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

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

class StudentInformationURLViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    var placemark: CLPlacemark!
    
    var account: Account? {
        return UdacityClient.sharedInstance().account
    }
    
    override func viewDidLoad() {

        URLTextField.delegate = self
        
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
            StudentInformation.Keys.UniqueKey: account!.key!,
            StudentInformation.Keys.FirstName: account!.firstName!,
            StudentInformation.Keys.LastName: account!.lastName!,
            StudentInformation.Keys.MapString: placemark.name!,
            StudentInformation.Keys.MediaURL: url,
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        setTextFieldBorderToDefault(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    private func setTextFieldBorderToDanger(textField: UITextField) {
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    private func setTextFieldBorderToDefault(textField: UITextField) {
        textField.layer.borderColor = nil
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5.0
    }
}

class SubmitInformationButton: UIButton {
    
    // MARK: Properties
    
    // constants for styling and configuration
    let darkerBlue = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
    let lighterBlue = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 44.0
    let borderedButtonCornerRadius: CGFloat = 4.0
    let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    
    // MARK: Initialization

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        applyTheme()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyTheme()
    }
    
    private func applyTheme() {
        layer.masksToBounds = true
        layer.cornerRadius = borderedButtonCornerRadius
        highlightedBackingColor = darkerBlue
        backingColor = lighterBlue
        backgroundColor = lighterBlue
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        titleLabel?.font = UIFont.systemFontOfSize(titleLabelFontSize)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSizeZero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
    }
}
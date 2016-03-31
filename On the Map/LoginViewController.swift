//
//  LoginViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        // ensure password field is cleared
        passwordField.text = ""
        print([
            "source": "viewWillAppear",
            "accountKey": UdacityClient.sharedInstance().accountKey,
            "sessionId": UdacityClient.sharedInstance().sessionId
            ])
    }
    
    override func viewDidDisappear(animated: Bool) {
        // clear password field
        passwordField.text = ""
        print([
            "source": "viewDidDisappear",
            "accountKey": UdacityClient.sharedInstance().accountKey,
            "sessionId": UdacityClient.sharedInstance().sessionId
        ])
    }

    @IBAction func login(sender: AnyObject) {
        
        view.endEditing(true)
        
        if emailField.text!.isEmpty {
            // Change email field to red
            setTextFieldBorderToDanger(emailField)
        }

        if passwordField.text!.isEmpty {
            // Change email field to red
            setTextFieldBorderToDanger(passwordField)
        }
        
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            print("E-mail and password field required.")
            showAlert(self, title: "Login Error", message: "E-mail and password field required.")

            return
        }
        
        let email = emailField.text!
        let password = passwordField.text!
        
        let parameters: [String:AnyObject] = [
            UdacityClient.JSONBodyKeys.Username: email,
            UdacityClient.JSONBodyKeys.Password: password
        ]
        
        checkNetworkConnection(UdacityClient.Constants.APIHost) { (success, error) in
            
            if !success {
                print(error!)
                showNetworkAlert(self)
                return
            }

            UdacityClient.sharedInstance().authenticateWithParameters(parameters) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    }
                    else {
                        self.setTextFieldBorderToDanger(self.emailField)
                        self.setTextFieldBorderToDanger(self.passwordField)
                    }
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        setTextFieldBorderToDefault(textField)
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
    
    @IBAction func signUp(sender: AnyObject) {
        print("signup")
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            print("error: \(errorString)")
        }
    }
}


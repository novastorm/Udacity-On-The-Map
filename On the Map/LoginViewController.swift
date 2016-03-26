//
//  LoginViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(sender: AnyObject) {
        guard let email = emailField.text, let password = passwordField.text else {
            print("E-mail and password field required.")
            return
        }
        
        let parameters: [String:AnyObject] = [
            UdacityClient.JSONBodyKeys.Username: email,
            UdacityClient.JSONBodyKeys.Password: password
        ]
        
        UdacityClient.sharedInstance().checkNetworkConnection(self) { (success, error) in
            
            if success {
                UdacityClient.sharedInstance().authenticateWithParameters(parameters) { (success, errorString) in
                    performUIUpdatesOnMain {
                        if success {
                            self.completeLogin()
                        }
                        else {
                            self.displayError(errorString)
                        }
                    }
                }
            }
            else {
                print(error!)
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        print("signup")
    }
    
    private func completeLogin() {
        print("completeLogin")
        print ("sessionId: \(UdacityClient.sharedInstance().sessionId)")
        print ("accountKey: \(UdacityClient.sharedInstance().accountKey)")
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            print("error: \(errorString)")
        }
    }
}


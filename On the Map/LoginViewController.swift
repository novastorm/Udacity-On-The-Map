//
//  LoginViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import FBSDKLoginKit
import UIKit

// MARK: LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ensure password field is cleared
        passwordField.text = ""

    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkNetworkConnection(nil) { (success, error) in
            if let _ = error {
                showNetworkAlert(self)
                return
            }
            
            if let currentAccessToken = FBSDKAccessToken.current() {
                ProgressOverlay.start(self, message: "Logging in") {
                    guard let tokenString = currentAccessToken.tokenString else {
                        return
                    }
                    
                    UdacityClient.sharedInstance.authenticateViaFacebook(tokenString) { (success, error) in
                        performUIUpdatesOnMain {
                            ProgressOverlay.stop() {
                                if let error = error {
                                    if error.code == NSURLErrorNotConnectedToInternet {
                                        self.displayError(error.localizedDescription)
                                    }
                                    else if error.code == NSURLErrorTimedOut {
                                        self.displayError(error.localizedDescription)
                                    }
                                    else if error.code == ErrorCodes.httpUnsucessful.rawValue {
                                        let response = error.userInfo["http_response"] as! HTTPURLResponse
                                        if response.statusCode == 403 {
                                            self.displayError("Check facebook account is linked", title: "Authorization error." )
                                            FBSDKLoginManager().logOut()
                                        }
                                        else {
                                            self.displayError("Recieved unexpected response code: \(response.statusCode)")
                                        }
                                    }
                                    else {
                                        self.displayError("Received unexpected error code: \(error.code) \(error.localizedDescription)")
                                    }
                                    return
                                }
                                
                                self.completeLogin()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // clear password field
        passwordField.text = ""
    }

    
    // MARK: Actions

    @IBAction func udacityLogin(_ sender: AnyObject) {
        
        view.endEditing(true)
        
        if emailField.text!.isEmpty {
            setTextFieldBorderToDanger(emailField)
        }

        if passwordField.text!.isEmpty {
            setTextFieldBorderToDanger(passwordField)
        }
        
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            displayError("E-mail and password field required.", title: "Login Error")
            return
        }
        
        let email = emailField.text!
        let password = passwordField.text!
        
        checkNetworkConnection(UdacityClient.Constants.APIHost) { (success, error) in
            
            if let _ = error {
                showNetworkAlert(self)
                return
            }

            ProgressOverlay.start(self, message: "Logging in") {
                UdacityClient.sharedInstance.authenticateViaUdacity(username: email, password: password) { (success, error) in
                    performUIUpdatesOnMain {
                        ProgressOverlay.stop() {
                            if let error = error {
                                if error.code == NSURLErrorNotConnectedToInternet {
                                    self.displayError(error.localizedDescription)
                                }
                                else if error.code == NSURLErrorTimedOut {
                                    self.displayError(error.localizedDescription)
                                }
                                else if error.code == ErrorCodes.httpUnsucessful.rawValue {
                                    let response = error.userInfo["http_response"] as! HTTPURLResponse
                                    if response.statusCode == 403 {
                                        self.displayError("Check username and password", title: "Authorization error.")
                                        self.setTextFieldBorderToDanger(self.emailField)
                                        self.setTextFieldBorderToDanger(self.passwordField)
                                    }
                                    else {
                                        self.displayError("Recieved unexpected response code: \(response.statusCode)")
                                    }
                                }
                                else {
                                    self.displayError("Received unexpected error code: \(error.code) \(error.localizedDescription)")
                                }
                                return
                            }
                            
                            self.completeLogin()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: AnyObject) {
        let signUpURL = "https://www.udacity.com/account/auth#!/signup"
        let url = URL(string: signUpURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    // MARK: Login

    fileprivate func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: Helper Utilities
    
    func displayError(_ message: String?, title: String? = nil) {
        showAlert(self, title: title, message: message)
        ProgressOverlay.stop() {}
    }
    
    func setTextFieldBorderToDanger(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    func setTextFieldBorderToDefault(_ textField: UITextField) {
        textField.layer.borderColor = nil
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5.0
    }
}


// MARK: - LoginViewController: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderToDefault(textField)
    }
}


// MARK: - LoginViewController: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        view.endEditing(true)
        
        if let _ = error {
            displayError(error.localizedDescription, title: "Login Failed")
            return
        }
        if ((result == nil) || result.isCancelled) {
            displayError("User cancelled login", title: "Login Cancelled")
            return
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {}
}

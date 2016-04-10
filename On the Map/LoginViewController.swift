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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        stopActivity(activityIndicator)
    }
    
    override func viewWillAppear(animated: Bool) {
        // ensure password field is cleared
        passwordField.text = ""

        if let currentAccessToken = FBSDKAccessToken.currentAccessToken() {
            startActivity(activityIndicator)
            if let tokenString = currentAccessToken.tokenString {
                UdacityClient.sharedInstance.authenticateViaFacebook(tokenString) { (success, error) in
                    performUIUpdatesOnMain {
                        
                        if let error = error {
                            if error.code == NSURLErrorNotConnectedToInternet {
                                self.displayError(error.localizedDescription)
                            }
                            if error.code == NSURLErrorTimedOut {
                                self.displayError(error.localizedDescription)
                            }
                            if (error.userInfo[NSUnderlyingErrorKey]!.userInfo["http_response"] as? NSHTTPURLResponse)?.statusCode == 403 {
                                self.displayError("Check facebook account is linked", title: "Authorization error." )
                                FBSDKLoginManager().logOut()
                            }
                            stopActivity(self.activityIndicator)
                            print(error)
                        }
                        
                        if success {
                            self.completeLogin()
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        checkNetworkConnection(nil) { (success, error) in
            if !success {
                showAlert(self, title: "No Connection", message: "Internet connection required for use.")
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        // clear password field
        passwordField.text = ""
    }

    
    // MARK: Actions

    @IBAction func udacityLogin(sender: AnyObject) {
        
        view.endEditing(true)
        startActivity(activityIndicator)
        
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
        
        UdacityClient.sharedInstance.authenticateViaUdacity(username: email, password: password) { (success, error) in
            performUIUpdatesOnMain {
                
                if let error = error {
                    if error.code == NSURLErrorNotConnectedToInternet {
                        self.displayError(error.localizedDescription)
                        return
                    }
                    if error.code == NSURLErrorTimedOut {
                        self.displayError(error.localizedDescription)
                        return
                    }
                    if (error.userInfo[NSUnderlyingErrorKey]!.userInfo["http_response"] as! NSHTTPURLResponse).statusCode == 403 {
                        self.displayError("Check username and password", title: "Authorization error.")
                        self.setTextFieldBorderToDanger(self.emailField)
                        self.setTextFieldBorderToDanger(self.passwordField)
                        return
                    }
                    
                    print(error)
                    return
                }
                
                self.completeLogin()
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let signUpURL = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.sharedApplication().openURL(NSURL(string: signUpURL)!)
    }
    
    
    // MARK: Login

    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNavigationController") as! UINavigationController
        stopActivity(activityIndicator)
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    // MARK: Helper Utilities
    
    func displayError(message: String?, title: String? = nil) {
        showAlert(self, title: title, message: message)
        stopActivity(activityIndicator)
    }
    
    func setTextFieldBorderToDanger(textField: UITextField) {
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    func setTextFieldBorderToDefault(textField: UITextField) {
        textField.layer.borderColor = nil
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5.0
    }
}


// MARK: - LoginViewController: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        setTextFieldBorderToDefault(textField)
    }
}


// MARK: - LoginViewController: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        view.endEditing(true)
        startActivity(activityIndicator)
        
        if let _ = error {
            displayError(error.localizedDescription, title: "Login Failed")
            return
        }
        if ((result == nil) || result.isCancelled) {
            displayError("User cancelled login", title: "Login Cancelled")
            return
        }

        guard let tokenString = result.token.tokenString else {
            displayError("No token in results", title: "Token not found")
            return
        }
        
        UdacityClient.sharedInstance.authenticateViaFacebook(tokenString) { (success, error) in
            performUIUpdatesOnMain {
                
                if let error = error {
                    if error.code == NSURLErrorNotConnectedToInternet {
                        self.displayError(error.localizedDescription)
                    }
                    if error.code == NSURLErrorTimedOut {
                        self.displayError(error.localizedDescription)
                    }
                    if (error.userInfo[NSUnderlyingErrorKey]!.userInfo["http_response"] as! NSHTTPURLResponse).statusCode == 403 {
                        self.displayError("Check facebook account is linked", title: "Authorization error." )
                    }
                    
                    print(error)
                    return
                }
                
                self.completeLogin()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {}
}
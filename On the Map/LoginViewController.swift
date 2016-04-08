//
//  LoginViewController.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import FBSDKLoginKit
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        // ensure password field is cleared
        passwordField.text = ""
//        facebookLoginButton
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

    @IBAction func udacityLogin(sender: AnyObject) {
        
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
        
        UdacityClient.sharedInstance().authenticateViaUdacity(username: email, password: password) { (success, error) in
            performUIUpdatesOnMain {
                
                if let error = error {
                    if error.code == NSURLErrorNotConnectedToInternet {
                        showAlert(self, title: nil, message: error.localizedDescription)
                        return
                    }
                    if error.code == NSURLErrorTimedOut {
                        showAlert(self, title: nil, message: error.localizedDescription)
                        return
                    }
                    if (error.userInfo[NSUnderlyingErrorKey]!.userInfo["http_response"] as! NSHTTPURLResponse).statusCode == 403 {
                        showAlert(self, title: "Authorization error.", message: "Check username and password" )
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
        let signUpURL = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.sharedApplication().openURL(NSURL(string: signUpURL)!)
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


// MARK: Facebook Login
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("facebook login")
        if let _ = error {
            showAlert(self, title: "Login Fail", message: error.description)
            return
        }
        if ((result == nil) || result.isCancelled) {
            showAlert(self, title: "Login Cancelled", message: "User cancelled login")
            return
        }

        guard let tokenString = result.token.tokenString else {
            showAlert(self, title: "Token not found", message: "No token in results")
            return
        }
        print(tokenString)
        UdacityClient.sharedInstance().authenticateViaFacebook(tokenString) { (success, error) in
            performUIUpdatesOnMain {
                
                if let error = error {
                    if error.code == NSURLErrorNotConnectedToInternet {
                        showAlert(self, title: nil, message: error.localizedDescription)
                        return
                    }
                    if error.code == NSURLErrorTimedOut {
                        showAlert(self, title: nil, message: error.localizedDescription)
                        return
                    }
                    if (error.userInfo[NSUnderlyingErrorKey]!.userInfo["http_response"] as! NSHTTPURLResponse).statusCode == 403 {
                        showAlert(self, title: "Authorization error.", message: "Check facebook account is linked" )
                        return
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
//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupActive = true

    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if (username.text == "" || password.text == "") {
        
            displayAlert("Error in form", message: "Please enter a username and/or password")
        
        } else {
            // Set up a spinner while we do the signup stuff
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if (signupActive == true) {
                // Associate Parse in the signup process
                var user = PFUser()
                user.username = username.text
                user.password = password.text
            
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                    // Stop the activity indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                    if (error == nil) {

                    // Signup successful
                    self.performSegueWithIdentifier("login", sender: self)
                
                    } else {
                    
                        if let errorString = error!.userInfo?["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed to Sign Up", message: errorMessage)
                    }
                })
            
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                   
                    // Stop the activity indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if (user != nil) {
                        
                        // Logged in
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo?["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed to Login Up", message: errorMessage)
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if (signupActive == true) {
            
            signUpButton.setTitle("Login", forState: UIControlState.Normal)
            registeredText.text = "Not Registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
            
        } else {
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already Registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // To check if user is already logged in.
    // We didn't do this in viewDidLoad because the method occurs before the segues are loaded. So we chose to do it in viewDidAppear
    override func viewDidAppear(animated: Bool) {
        
//        if (PFUser.currentUser() != nil) {
//            self.performSegueWithIdentifier("login", sender: self)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


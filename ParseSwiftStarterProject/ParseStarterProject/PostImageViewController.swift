//
//  PostImageViewController.swift
//  ParseStarterProject
//
//  Created by Mashfique Anwar on 7/1/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var photoChosen = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary       // Can use camera as well
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        photoChosen = true
    }
    
    // This will occur when the user has finished picking the image
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
       
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
    }
    
    @IBOutlet var message: UITextField!
    
    @IBAction func postImage(sender: AnyObject) {
        
        // IMPORTANT NOTE: Activity indicator inteferes with the alerts! So make sure to end the activity indicator before putting up an alert/error message
        
        if (photoChosen == false) {
            displayAlert("Error!", alertMessage: "Please choose a picture from the Picture Library")
            return
        }
            
        // Setup the activity indicator
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)     // will make the activity indicator full screen
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)     // "alpha" is for transparency
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // Create custom class called "Post"
        var post = PFObject(className: "Post")
        
       
        
        if (message.text == "") {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            displayAlert("Error", alertMessage: "Please enter a message in the text field")
            //println("Reached HERE")
            
        } else {
                
            // Post the image: by converting the image to a file suitable for Parse and then storing it to the "post" class
                
            println(UIImage(named: "placeholder-image.png")?.description)
            println(imageToPost.image?.description)
                
            post["message"] = message.text
            post["userId"] = PFUser.currentUser()!.objectId!
                
            let imageData = UIImagePNGRepresentation(imageToPost.image)
                
            let imageFile = PFFile(name: "image.png", data: imageData)
                
            post["imageFile"] = imageFile
                
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                    
                self.activityIndicator.stopAnimating()
                    
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                if (error == nil) {
                        
                    println("success")
                    
                    self.photoChosen = false
                    
                    // Reset the picture and message text
                    self.imageToPost.image = UIImage(named: "placeholder-image.png")
                    self.message.text = ""
                    
                    self.displayAlert("Image Posted!", alertMessage: "Your image has been posted successfully")
                
                } else {
                    
                    self.displayAlert("Could not post image", alertMessage: "Please try again later")
                    // We could possibly extract the error message from Parse to make it fancier!
                }
                    
            }
        }
    
        
        
    }
    
    func displayAlert(title: String, alertMessage: String) {
        
        var alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

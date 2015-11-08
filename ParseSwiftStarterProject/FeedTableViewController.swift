//
//  FeedTableViewController.swift
//  ParseStarterProject
//
//  Created by Mashfique Anwar on 7/4/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

var messages = [String]()
var usernames = [String]()
var imageFiles = [PFFile]()
var usersDictionary = [String: String]()      // Dictionary to link userids to usernames

class FeedTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For username: The "follower" class doesn't have a "username" property. So we use some code excerpt from TableViewController
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock ({ (objects, eror) -> Void in
            
            if let users = objects {
                
                usernames.removeAll(keepCapacity: true)    // Clear array containing empty string
                messages.removeAll(keepCapacity: true)      // Same as above
                imageFiles.removeAll(keepCapacity: true)
                usersDictionary.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        usersDictionary[user.objectId!] = user.username!     // Associate userids with usernames and put them in a dictionary
                    }
                }
                
            }
            })
            // We need to go to the "followers" class and look at the people followed by the current user
            var getFollowedUsersQuery = PFQuery(className: "followers")
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            //println(PFUser.currentUser()!.objectId!)
            getFollowedUsersQuery.findObjectsInBackgroundWithBlock ({ (objects, error) -> Void in
            
                if let objects = objects {
                    //println(objects)
                    for object in objects {
                    
                        // Get the users that we're following
                        var followedUser = object["following"] as String
                        //println(followedUser)
                        var query = PFQuery(className: "Post")
                    
                        query.whereKey("userId", equalTo: followedUser)
                        
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                            
                            if let objects = objects {
                                //println(objects)
                                for object in objects {
                                    
                                    messages.append(object["message"] as String!)
                                    imageFiles.append(object["imageFile"] as PFFile)
                                    usernames.append(usersDictionary[object["userId"]as String]! )
                                    
                                    
                                    // We have userids and usernames stored in the dictionary "users" So what we do in the last
                                    // line here is- we use the userid from the dictionary to check with userid in "post" class and
                                    // get the username again from the dictionary
                                    
                                    self.tableView.reloadData()
                                }
                                //println(self.users["cgRnt7tPzY"]!)        // Print specific user (Inti)
                                //println(self.usernames)
                                //println(self.messages)
                                //println(self.imageFiles)
                            }
                        })
                    
                    }
                }
            })
        //println(usernames.count)
        
    }
    
    //--------- This will make navigation bar go away when scrolling! ------------//
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // This isn't the usual cell. So we cast to a user defined "cell"
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as cell

        //Get the images and download them from parse:
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
             
                myCell.postedImage.image = downloadedImage
            }
        }
        
        //myCell.postedImage.image = UIImage(named: "placeholder-image.png")
        myCell.username.text = usernames[indexPath.row]
        myCell.message.text = messages[indexPath.row]
        
        return myCell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

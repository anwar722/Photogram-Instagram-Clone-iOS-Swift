//
//  TableViewController.swift
//  ParseStarterProject
//
//  Created by Mashfique Anwar on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

//################## IMPORTANT NOTE: "findObjectsInBackgroundWithBlock" doesnt't occur in order! So keep that in mind!

import UIKit
import Parse

class TableViewController: UITableViewController {

    var usernames = [""]
    var userids = [""]
    var isFollowing = ["":false]      // Dictioary corresponding to users that I (the current user) am following (first entry is the userid)
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        println("Refreshed")
        
        // ------------------------------------ For retrieving from Parse -----------------------------------//
        
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock ({ (objects, eror) -> Void in
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)    // Clear array containing empty string
                self.userids.removeAll(keepCapacity: true)      // Same as above
                self.isFollowing.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {    // "user" was originally an AnyObject type. We cast it to PFUser to do anything useful
                        
                        if user.objectId != PFUser.currentUser().objectId {
                            
                            // Don't want to add ourselves to the list. So we check for "currentUser"
                            self.usernames.append(user.username)
                            self.userids.append(user.objectId)
                            
                            // Check for already followed people (ticked people)
                            var query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: PFUser.currentUser()?.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)     // the user that we're looping through
                            
                            // Run the query
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                if let objects = objects {  // Check to see if objects are nil or not. If they are not nil, we unwrap them
                                    
                                    if (objects.count > 0) {
                                        self.isFollowing[user.objectId!] = true
                                    }
                                    else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                if (self.isFollowing.count == self.usernames.count) {
                                    self.tableView.reloadData()
                                    // update the table only when the two arrays have same number of elements
                                    self.refresher.endRefreshing()
                                }
                                
                            })
                        }
                        
                    }
                    
                }
                
            }
            println(self.usernames)
            println(self.userids)
            
            //self.tableView.reloadData()     // Moved UP to the query!!! Because it was causing an error- the app would try to reload the table before the isFollowing array was actually constructed
            
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //------------------------------------- For pull to refresh ---------------------------------------------//
        
        refresher = UIRefreshControl()      // empty refresh control
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")   // This will appear when the user pulls the table
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)    // Run the refresh function when the value has changed, i.e., when someone has pulled the table down and initiated the pull to refresh function
        
        self.tableView.addSubview(refresher)
        
        refresh()

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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = usernames[indexPath.row]

        let followedObjectId = userids[indexPath.row]
        
        if (isFollowing[followedObjectId] == true) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark     // Put tick mark on users that I am already following
        }

        return cell
    }
    

    // This will take care of the list of people the current user (or myself) is following. Basically this will help with following and unfollowing
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!    // Define the cell
        
        let followedObjectId = userids[indexPath.row]
        
        if (isFollowing[followedObjectId] == false ) {
            
            isFollowing[followedObjectId] = true
        
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark     // Put a checkmark on selected table cells
        
            var following = PFObject(className: "followers")        // followers is the class we created in parse.com
            following["following"] = userids[indexPath.row]         // "following" will be the id of the user that's tapped on
            following["follower"] = PFUser.currentUser().objectId   // current user is the "follower" of the person that was tapped on
        
            following.saveInBackground()
            
        } else {
            
            isFollowing[followedObjectId] = false
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            // Can use pretty much the same query that we used in viewDidLoad
            // Check for already followed people (ticked people)
            var query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: PFUser.currentUser()?.objectId!)
            query.whereKey("following", equalTo: userids[indexPath.row])     // the user that we're looping through
            
            // Run the query
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if let objects = objects {  // Check to see if objects are nil or not. If they are not nil, we unwrap them
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                    
                    }
                }
                
                if (self.isFollowing.count == self.usernames.count) {
                    self.tableView.reloadData()
                    // update the table only when the two arrays have same number of elements
                }
            })
            
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        let shareMenu = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let action = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            PFUser.logOut()
            //var currentUser = PFUser.currentUser()
            self.performSegueWithIdentifier("logout", sender: self)
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }
        
        shareMenu.addAction(action)
        shareMenu.addAction(cancelAction)
        
        self.presentViewController(shareMenu, animated: true, completion: nil)
        
    }
    

}

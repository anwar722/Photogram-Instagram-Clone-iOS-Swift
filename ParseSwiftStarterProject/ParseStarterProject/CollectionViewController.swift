//
//  CollectionViewController.swift
//  ParseStarterProject
//
//  Created by Mashfique Anwar on 7/5/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For username: The "follower" class doesn't have a "username" property. So we use some code excerpt from TableViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        //#warning Incomplete method implementation -- Return the number of sections
//        return 1
//    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return usernames.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let myCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as CollectionViewCell
    
        //Get the images and download them from parse:
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCollectionCell.imageCell.image = downloadedImage
            }
        }
        
        //myCollectionCell.imageCell.image = UIImage(named: "placeholder-image.png")
    
        return myCollectionCell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

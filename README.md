# Photogram (iOS Instagram Clone)

This is an Instagram Clone that I made using Swift and Parse for learning purposes. This app was made following the Complete iOS 8 course in Udemy by Rob Percival. However, I played around a bit more by adding the features like the CollectionView feed, safe logout, the TabViewController and various notification styles.

**Features/Procedures of this app that can be reused in others:**
- Login and Logout methods
- Feeding to and retrieving media from Parse
- User Tables (Followers/Following)
- Collection View to display multiple media in small boxes on the screen

**Files of Interest:**
(located in ParseSwiftStarterProject/ParseStarterProject/)
- ViewController.swift: Signup/login Screen

- TableViewController.swift: User Tables (Followers/Following)

- FeedTableViewController.swift: Table-style Media feed of posts by user's friends. This file uses Cell.swift, which has a class "cell" which represents the cells in the table feed.

- CollectionViewController.swift: Multi-grid style media feed of posts by user's friends. This file uses CollectionViewCell.swift, which has a class "CollectionViewCell" that represent the cells in this particular view controller.

- PostImageViewController.swift: Upload images

Please note that this app was built merely for learning purposes and it doesn't place emphasis on UI. I uploaded only the swift files and not the XCode Project files as I want to use this repository as a future reference guide. Also, these Instagram-specific features have **not** been implemented in the app:
- Hastagging
- Photo filters




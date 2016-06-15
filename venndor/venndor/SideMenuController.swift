//
//  SideMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-09.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class SideMenuController: UITableViewController {
    
    @IBAction func logOut(sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
        
    }
    
    @IBAction func postItem() {
        self.performSegueWithIdentifier("postInfo", sender: self)
    }
    
    @IBOutlet weak var profilePic = UIImageView(frame: CGRectMake(0, 0, 50, 50))
    
    
    @IBOutlet weak var browseIconButton: UIButton!
    
    @IBOutlet weak var myMatchesIconButton: UIButton!
    
    @IBOutlet weak var myPostsIconButton: UIButton!
    
    @IBOutlet weak var notificationsIconButton: UIButton!
    
    @IBOutlet weak var settingsIconButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic?.layer.borderWidth = 2.0
        profilePic?.layer.masksToBounds = false
        profilePic?.layer.borderColor = UIColor.whiteColor().CGColor
        profilePic?.layer.cornerRadius = (profilePic?.frame.size.width)!/2
        profilePic?.clipsToBounds = true
//        profilePic?.image = UIImage(named: "app landing page background.png")
        
        browseIconButton.setImage(UIImage(named: "Home-50"), forState: UIControlState.Normal)
        myMatchesIconButton.setImage(UIImage(named: "Shopping Cart Loaded-50"), forState: UIControlState.Normal)
        myPostsIconButton.setImage(UIImage(named: "New Product-50"), forState: UIControlState.Normal)
        notificationsIconButton.setImage(UIImage(named: "Megaphone-50"), forState: UIControlState.Normal)
        settingsIconButton.setImage(UIImage(named: "Settings-50"), forState: UIControlState.Normal)
        
        
    }
    
    
    
    
    
}
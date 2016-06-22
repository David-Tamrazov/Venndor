//
//  SplashViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-20.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userManager = UserManager()
        let itemManager = ItemManager()
        
        
        userManager.retrieveUserByEmail(LocalUser.email) { user, error in
            guard error == nil else {
                print("Error retrieving user from database: \(error)")
                return
                }
            
            if user != nil {
                LocalUser.user = user
            }
            else {
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email) { user, error in
                    LocalUser.user = user
                }
            }
            
            itemManager.retrieveMultipleItems(3, filter: nil) { items, error in
                guard error == nil else {
                    print("Error retrieving items from server: \(error)")
                    return
                }
                
                if items != nil {
                    GlobalItems.items = items!
                    self.triggerSegue()
                }
            }
        }
    }
    
    func triggerSegue(){
        self.performSegueWithIdentifier("showBrowse", sender: self)
    }
    
}


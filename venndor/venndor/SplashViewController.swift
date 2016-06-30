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
                print("\(LocalUser.user.email)")
                //fix for ui testing
//                self.triggerSegue()
            }
            else {
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email) { user, error in
                    LocalUser.user = user
                    self.triggerSegueTutorial()
                }
            }
            itemManager.retrieveMultipleItems(5, offset: nil, filter: nil) { items, error in
                guard error == nil else {
                    print("Error retrieving items from server: \(error)")
                    return
                }
                
                if items != nil {
                    GlobalItems.items = items!
                    for x in 0..<GlobalItems.items.count{
                        while GlobalItems.items[x].photos == nil {
                            continue
                        }
                    }
                    self.triggerSegue()
                }
            }
        }
    }
    
    func triggerSegue(){
        self.performSegueWithIdentifier("showBrowse", sender: self)
    }
    func triggerSegueTutorial(){
        self.performSegueWithIdentifier("goTutorial", sender: self)
    }
    
}


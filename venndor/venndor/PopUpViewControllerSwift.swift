//
//  PopUpViewControllerSwift.swift
//  NMPopUpView
//
//  Created by Nikos Maounis on 13/9/14.
//  Copyright (c) 2014 Nikos Maounis. All rights reserved.
//

import UIKit
import QuartzCore

class PopUpViewControllerSwift : UIViewController {
    
    var screenSize = UIScreen.mainScreen().bounds
    var matchedItem: Item!
    var matchedPrice: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        
        let userManager = UserManager()
        let matchManager = MatchesManager()
        
        let item = matchedItem

    
        
        //create the match on the server
        let newMatch = Match(itemID: matchedItem.id, buyerID: LocalUser.user.id, sellerID: matchedItem.owner, matchedPrice: matchedPrice)
        matchManager.createMatch(newMatch) { match, error in
            guard error == nil else {
                print("Error creating match on server: \(error)")
                return
            }
            
            if let match = match {
                
                //update the LocalUser's matches info
                LocalUser.user.matches[match.id!] = item.id
                LocalUser.user.nuMatches = LocalUser.user.nuMatches + 1
                let update = ["matches": LocalUser.user.matches, "nuMatches": LocalUser.user.nuMatches]

                
                //update the LocalUser on the server
                userManager.updateUserById(LocalUser.user.id, update: update as! [String : AnyObject]) { error in
                    guard error == nil else {
                        print("Error updating the local user's matches: \(error)")
                        return
                    }
                    
                    print("LocalUser matches succesfully updated.")
                }
                
                //retrieve the item's owner from the server and update their info as well
                userManager.retrieveUserById(self.matchedItem.owner) { user, error in
                    guard error == nil else {
                        print("Error retrieving user for match update: \(error)")
                        return
                    }
                    
                    if let user = user {
                        //update item owner's match info
                        user.matches[match.id!] = item.id
                        user.nuMatches = user.nuMatches + 1
                        user.ads[item.id!] = "Matched"
                        
                        //post the update to the server
                        let update = ["matches": user.matches, "nuMatches": user.nuMatches, "ads": user.ads]
                        userManager.updateUserById(user.id, update: update as! [String:AnyObject]) { error in
                            guard error == nil else {
                                print("Error updating item owner's matches: \(error)")
                                return
                            }
                            
                            print("Item owner's matches updated.")
                        }
                    }
                }

            }
        }
    }
    
    func setupBackground() {
        self.view.frame = screenSize
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        let backgroundImage = UIImage(named: "match background.png")
        let backgroundImageView = UIImageView(frame: screenSize)
        backgroundImageView.image = backgroundImage
        self.view.addSubview(backgroundImageView)
    }
    
    func showInView(aView: UIView!, price: Double, item: Item)
    {
        let message = UILabel(frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.2, width: screenSize.width*0.8, height: screenSize.height*0.2))
        message.text = "You Matched!"
        self.view.addSubview(message)
        message.textColor = UIColor.whiteColor()
        message.textAlignment = .Center
        message.font = message.font.fontWithSize(40)
        let matchPrice = UILabel(frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.33, width: screenSize.width*0.8, height: screenSize.height*0.2))
        matchPrice.textColor = UIColor.whiteColor()
        matchPrice.textAlignment = .Center
        matchPrice.font = message.font.fontWithSize(60)
        matchPrice.text = "$\(price)"
        self.view.addSubview(matchPrice)
        let widthFactor: CGFloat = 0.033
        let promptFrame = CGRectMake(screenSize.width*widthFactor, screenSize.height*0.55, screenSize.width*(1-2*widthFactor), screenSize.height*0.15)
        setupPrompt(item.name, item: item, screenSize: screenSize, frame: promptFrame)
        
        aView.addSubview(self.view)
        self.showAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func closePopup(sender: AnyObject) {
        self.removeAnimate()
    }
}

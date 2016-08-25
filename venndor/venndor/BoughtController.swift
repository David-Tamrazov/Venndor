//
//  BoughtController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-08-02.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct BoughtController {

    
    static var globalController = BoughtController()
    
    func sendSellerNotification(seller: User, match: Match) {
        OneSignal.postNotification(["contents": ["en": "\(LocalUser.firstName) wants to buy your \(match.itemName) for $\(match.matchedPrice)!"], "include_player_ids": ["\(seller.pushID)"]])
    }
    
    func updateSeller(item: Item, seller: User, soldPrice: Int) {

        //function should update the sellers item, move the item from posted to sold
        
        let filter = "itemID = \(item.id)"
        PostManager.globalManager.retrievePostByFilter(filter) { post, error in
            guard error == nil else {
                print("Error retrieving post for update in Buy controller: \(error)")
                return
            }
            
            if let post = post {
                post.buyerID = LocalUser.user.id
                post.buyerName = "\(LocalUser.user.firstName) \(LocalUser.user.lastName)"
                post.soldPrice = soldPrice
                post.dateSold = NSDate()
                post.sold = 1
                
                seller.soldItems[post.id] = item.id
                seller.nuItemsSold! += 1
                
                self.updatePostOnPurchase(post)
                self.updateSellerOnPurchase(seller)
            }
        }
    }
    
    func updatePostOnPurchase(post: Post) {
        let update = ["buyerID": post.buyerID, "buyerName":post.buyerName, "soldPrice": post.soldPrice, "dateSold":TimeManager.formatter.stringFromDate(post.dateSold), "sold": post.sold]
        
        PostManager.globalManager.updatePostById(post.id, update: update as! JSON) { error in
            guard error == nil else {
                print("Error updating post object in Buy Controller: \(error)")
                return
            }
            
            print("Succesfully updated post object on the server.")
        }
        
    }
    
    func updateSellerOnPurchase(seller: User) {
        let update = ["soldItems": seller.soldItems, "nuItemsSold": seller.nuItemsSold]
        UserManager.globalManager.updateUserById(seller.id, update: update as! JSON) { error in
            guard error == nil else {
                print("Errr updating seller in Buy controller: \(error)")
                return
            }
            
            print("Succesfuly updated seller object on the server.")
        }
    }

    
    func updateBuyer(item: Item, buyer: User, match: Match) {

        //function should update the buyer, move the item from matched to bought
        
        let filter = "itemID = \(item.id)"
        match.bought = 1
        match.dateBought = NSDate()
        buyer.boughtItems[item.id] = item.owner
        buyer.nuItemsBought! += 1
        
        self.updateMatchOnPurchase(match)
        self.updateBuyerOnPurchase(buyer)
        
    }
    
    func updateMatchOnPurchase(match: Match) {
        let update = ["bought": match.bought, "dateBought": TimeManager.formatter.stringFromDate(match.dateBought)]
        MatchesManager.globalManager.updateMatchById(match.id!, update: update as! JSON) { error in
            guard error == nil else {
                print("Error updating match in Buy controller: \(error)")
                return
            }
            
            print("Succesfully updated match object in Buy controller.")
        }
    }
    
    func updateBuyerOnPurchase(buyer: User) {
        let update = ["boughtItems": buyer.boughtItems, "nuItemsBought": buyer.nuItemsBought, "matches": buyer.matches]
        UserManager.globalManager.updateUserById(buyer.id, update: update as! JSON) { error in
            guard error == nil else {
                print("Error updating user in Buy controller: \(error)")
                return
            }
            
            print("Succesfully updated the buyer in Buy controller.")
        }
    }
    
    func updateMarket(item: Item, match: Match) {

        //function should update the market for all users and remove the item from the potential pool of items.
        
        //update the users in the market
        let userArray = self.getArrayForUpdate(item.matches, keyOrValue: "value")
        print("User array passed to update users: \(userArray)")
        updateUsers(userArray.filter({ $0 != LocalUser.user.id }), match: match)
        
        //remove all other match objects
        removeMatches(match)
        
        //remove the match thumbnails
        let matchArray = self.getArrayForUpdate(item.matches, keyOrValue: "key")
        removeMatchThumbnails(matchArray.filter({ $0 != match.id }))
        
    }

    
    func updateUsers(users: [String], match: Match) {
        print("User array recieved by updateUsers: \(users)")
        var filterString = ""
        var index = 0
        
        if users.count == 0 {
            return
        }
        
        for user in users {
            filterString = index == 0 ? "(_id = \(user))" : "\(filterString) or (_id = \(user))"
            index += 1
        }
        
        print("Filter for updateUsers: \(filterString)")
        print("Your user ID: \(LocalUser.user.id)")
        
        UserManager.globalManager.retrieveMultipleUsers(filterString) { users, error in
            guard error == nil else {
                print("Error getting match users in Buy controller: \(error)")
                return
            }
            
            if let users = users {
                
                for user in users {
                    user.matches.removeValueForKey(match.id!)
                }
                
                let dict = self.buildUserUpdates(users)
                UserManager.globalManager.updateMultipleUsers(dict) { error in
                    guard error == nil else {
                        print("Error updating users from Buy controller: \(error)")
                        return
                    }
                    
                    print("Succesfully updated users in Buy controller.")
                }
                
            }
        }
    }
    
    func buildUserUpdates(users: [User]) -> [[String:AnyObject]] {
        var updateDict = [[String:AnyObject]]()
        for user in users {
            let temp = ["_id":user.id, "matches":user.matches]
            updateDict.append(temp as! [String : AnyObject])
        }
        return updateDict
    }
    
    func getArrayForUpdate(dict: [String:AnyObject], keyOrValue: String) -> [String] {
        var array = [String]()
        
        for (key, value) in dict {
            let addition = keyOrValue == "key" ? key : value as! String
            array.append(addition)
        }
        
        return array
    }
    
    func removeMatchThumbnails(deleteArray: [String]) {
        for matchID in deleteArray {
            RESTEngine.sharedEngine.removeImageFolderById(matchID, success: { response in }, failure: { error in print("Error deleting match thumbnail: \(error) for ID: \(matchID)") })
        }
    }
    

    func removeMatches(match: Match) {
        let filter = "(_id != \(match.id!)) and (itemName = \(match.itemName))"
        print("Delete matches filter: \(filter)")
        MatchesManager.globalManager.deleteMultipleMatchesById(nil, filter: filter) { error in
            guard error == nil else {
                print("Error deleting matches from server in Buy: \(error)")
                return
            }
    
            print("Succesfully deleted all match objects associated with bought item.")
        }
    }
    

}
//
//  Post.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-26.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class Post: NSObject {
    var id: String!
    var itemID: String!
    var itemName: String!
    var itemDescription: String!
    var itemPickupLocation: String!
    var userID: String!
    var buyerID: String!   //to be set when item is sold
    var buyerName: String! //to be set when item is sold
    var minPrice: Int!
    var soldPrice: Int! //to be set when item is sold
    var thumbnail: UIImage!
    var sold: Int!
    var dateSold: NSDate! //to be set when item is sold
    
    init(itemID: String, itemName: String, itemDescription: String, itemPickupLocation: String, userID: String, minPrice: Int, thumbnail: UIImage) {
        self.itemID = itemID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemPickupLocation = itemPickupLocation
        self.userID = userID
        self.minPrice = minPrice
        self.thumbnail = thumbnail
        self.sold = 0
    }
    
    init(json: JSON) {
        self.id = json["_id"] as! String
        self.itemID = json["itemID"] as! String
        self.itemName = json["itemName"] as! String
        self.itemDescription = json["itemDescription"] as! String
        self.itemPickupLocation = json["itemPickupLocation"] as! String 
        self.userID = json["userID"] as! String
        self.buyerID = json["buyerID"] == nil ? nil : json["buyerID"] as! String
        self.buyerName = json["buyerName"] == nil ? nil : json["buyerName"] as! String
        self.minPrice = json["minPrice"] as! Int
        self.soldPrice = json["soldPrice"] == nil ? nil : json["soldPrice"] as! Int
        self.sold = json["sold"] as! Int
        self.dateSold = json["dateSold"] == nil ? nil : TimeManager.formatter.dateFromString(json["dateSold"]! as! String)
    }
}
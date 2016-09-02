//
//  Item.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

struct GlobalItems {
    static var items = [Item]()
    static var currentCategory: String?
    static var itemsToUpdate = [Item]()
    static var currentSearch = [String]()
}

class Item: NSObject {
    var name: String
    var details: String
    var id: String!
    var photos: [UIImage]?
    var photoCount: Int!
    var owner: String
    var ownerName: String
    var category: String
    var condition: Int
    var itemAge: String
    var minPrice: Int
    var pickupLocation: String!
    var bought: Int
    
    //key: match object id, value: user who owns match object
    var matches: [String:AnyObject]!
    
    //metrics
    var timeMatched: NSDate?
    var timeBought: NSDate?
    var nuSwipesLeft: Int!
    var nuSwipesRight: Int!
    var nuMatches: Int!
    var offersMade: [Double]!
    var avgOffer: Double!
    
    var formatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }
    
    
    //photos, name/title, category, question1, question2, condition, description, address, minPrice
    
    //init from the server
    init(json: JSON) {
        name = json["name"] as! String
        details = json["details"] as! String
        id = json["_id"] as! String
        photoCount = json["photoCount"] as! Int
        owner = json["owner"] as! String
        ownerName =  json["ownerName"] as! String
        category = json["category"] as! String
        condition = json["condition"] as! Int
        itemAge = json["itemAge"] as! String
        minPrice = json["minPrice"] as! Int
        pickupLocation = json["pickupLocation"] as! String
        matches = ParserManager.globalManager.getDict(json["matches"]!)
        bought = json["bought"] as! Int
        timeMatched = json["timeMatched"] == nil ? nil : TimeManager.formatter.dateFromString(json["timeMatched"] as! String)
        timeBought = json["timeBought"] == nil ? nil : TimeManager.formatter.dateFromString(json["timeBought"]! as! String)
        nuSwipesLeft = json["nuSwipesLeft"] as! Int
        nuSwipesRight = json["nuSwipesRight"] as! Int
        nuMatches =  json["nuMatches"] as! Int
        offersMade = ParserManager.globalManager.getDoubleArray(json["offersMade"]!)
        avgOffer = json["avgOffer"] as! Double
    }
    
    //init from the app
    init(name: String, description: String, owner: String, ownerName: String, category: String, condition: Int, photos: [UIImage], itemAge: String, minPrice: Int, pickupLocation: String) {
        self.name = name
        self.details = description
        self.owner = owner
        self.ownerName = ownerName
        self.photos = photos
        self.photoCount = photos.count
        self.category = category
        self.condition = condition
        self.itemAge = itemAge
        self.minPrice = minPrice
        self.pickupLocation = pickupLocation
        self.matches = [String:AnyObject]()
        self.bought = 0 
        self.timeMatched = nil
        self.timeBought = nil
        self.nuSwipesLeft = 0
        self.nuSwipesRight = 0
        self.nuMatches = 0
        self.offersMade = [Double]()
        self.avgOffer = 0
    }
    
    func setAverageOffer() {
        var x = 0.0
        for offer in self.offersMade {
            x += offer
        }
        self.avgOffer = x / Double(self.offersMade.count)
    }

}
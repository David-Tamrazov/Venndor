//
//  BoughtController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-08-02.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct BoughtController {
    func sendSellerNotification(seller: User, match: Match) {
        OneSignal.postNotification(["contents": ["en": "\(LocalUser.firstName) wants to buy your \(match.itemName) for $\(match.matchedPrice)!"], "include_player_ids": ["\(seller.pushID)"]])
    }
    func updateSeller(match: Match) {
        //function should update the sellers item, move the item from posted to sold
        
    }
    func updateBuyer(match: Match) {
        //function should update the buyer, move the item from matched to bought
        
    }
    func updateMarket(match: Match) {
        //function should update the market for all users and remove the item from the potential pool of items.
    }
}
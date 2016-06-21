//
//  Item.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct GlobalItems {
    static var items = [Item]()
}

class Item: NSObject {
    var name: String
    var details: String
    var id: String
    var owner: String
    
    init(json: JSON) {
        name = json["name"] as! String
        details = json["details"] as! String
        id = json["_id"] as! String
        owner = json["owner"] as! String 
    }
}
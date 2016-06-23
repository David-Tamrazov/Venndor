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
    
    func loadNextItem() -> Void {
//        let itemManager = ItemManager()
        /*
        for x in 0...9 {
            if x < 9 {
                GlobalItems.items[x] = GlobalItems.items[x+1]
            }
            else {
                
            }
        }
        */
    }
}

class Item: NSObject {
    var name: String
    var details: String
    var id: String!
    var photos: [UIImage]?
    var photoStrings: [String]!
    var owner: String
    let parser = ParserManager()
    
    //init from the server
    init(json: JSON) {
        name = json["name"] as! String
        details = json["details"] as! String
        id = json["_id"] as! String
        owner = json["owner"] as! String
        photoStrings = parser.getArray(json["photoStrings"]!)
    }
    
    //init from the app 
    init(name: String, description: String, owner: String, photos: [UIImage]?) {
        self.name = name
        self.details = description
        self.owner = owner
        self.photos = photos
    }
    
    func getImagesFromStrings(imageStrings: [String]) {
        var images = [UIImage]()
        for str in imageStrings {
            let data = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let img = UIImage(data: data!)
            images.append(img!)
        }
        self.photos = images
    }
    
    func getStringsFromImages(images: [UIImage]) {
        var imageStrings = [String]()
        for img in images {
            let imgData = UIImageJPEGRepresentation(img, 1.0)
            var imgString: String?
            if let data = imgData {
                imgString = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

            }
            if let str = imgString {
                imageStrings.append(str)
            }
        }
        self.photoStrings = imageStrings
    }
}
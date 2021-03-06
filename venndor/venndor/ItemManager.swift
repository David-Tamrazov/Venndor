//
//  ItemManager.swift
//  Testing- Backend
//
//  Created by David Tamrazov on 2016-06-18.
//  Copyright © 2016 David Tamrazov. All rights reserved.
//

import Foundation

struct ItemManager {
    
    static let globalManager = ItemManager()
    
    func createItem(item: Item, completionHandler: (ErrorType?) -> () ) {

        let params = ["name": item.name, "details": item.details, "photoCount": item.photoCount, "owner": item.owner, "ownerName": item.ownerName, "category": item.category,  "condition": item.condition, "itemAge": item.itemAge, "minPrice": item.minPrice, "pickupLocation":item.pickupLocation, "matches": item.matches, "bought": item.bought, "nuSwipesLeft": item.nuSwipesLeft, "nuSwipesRight": item.nuSwipesRight, "nuMatches": item.nuMatches, "offersMade": item.offersMade, "avgOffer": item.avgOffer] as JSON
    
        RESTEngine.sharedEngine.addItemToServerWithDetails(params,
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    item.id = id as! String
                    RESTEngine.sharedEngine.addItemImagesById(item.id, images: item.photos!, success: { success in }, failure: { error in })
                }
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func retrieveItemById(id: String, completionHandler: (Item?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemById(id,
            success: { response in
                if let response = response, _ = response["_id"] {
                    let item = Item(json: response)
                    completionHandler(item, nil)
                }
                else {
                    completionHandler(nil, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMultipleItems(count: Int, offset: Int?, filter: String?, fields: [String]?, completionHandler: ([Item]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemsFromServer(count, offset: offset, filter: filter, fields: fields,
            success: { response in
                
                if let response = response, result = response["resource"] {
                    var itemsArray = [Item]()
                    let arr = result as! NSArray
                    for data in arr {
                        let data = data as! JSON
                        let item = Item(json: data)
                        itemsArray.append(item)
                    }
                    completionHandler(itemsArray, nil)
                }
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    
    func retrieveItemImage(item: Item, imageIndex: Int, completionHandler: (UIImage?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getImageFromServerById(item.id, fileName: "image\(imageIndex)",
            success: { response in
               
                if let response = response, content = response["content"] as? NSString {
                    let fileData = NSData(base64EncodedString: content as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    if let data = fileData, img = UIImage(data: data) {
                        
                        if item.photos != nil {
                            item.photos?.append(img)
                        }
                        else {
                            item.photos = [img]
                        }
                        
                        completionHandler(img, nil)
                    }
                        
                    else {
                        print("Error parsing server data into image.")
                        completionHandler(nil, nil)
                    }
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func deleteMultipleItemsById(ids:[String]?, filter: String?, completionHandler: (ErrorType?) -> ()) {
        var resourceArray = [[String:AnyObject]]()
        
        if let ids = ids {
            for id in ids {
                let dict = ["_id": id]
                resourceArray.append(dict)
            }
        }
        
        RESTEngine.sharedEngine.deleteMultipleItemsFromServer(resourceArray,
                                                                success: { _ in completionHandler(nil) }, failure: { error in completionHandler(error)})
    }
    
    func updateItemById(id: String, update: [String:AnyObject], completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.updateItemById(id, itemDetails: update,
            success: { response in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func updateItemMetrics(items: [Item], completionHandler:(ErrorType?) -> () ) {
        var resourceArray = [[String:AnyObject]]()
        for item in items {
            let updateDict = ["_id": item.id, "nuSwipesLeft": item.nuSwipesLeft!, "nuSwipesRight": item.nuSwipesRight!]
            resourceArray.append(updateDict as! [String : AnyObject])
        }
        
        RESTEngine.sharedEngine.updateItems(resourceArray, success: { _ in }, failure: { error in completionHandler(error) })
    }
    
    func constructFeedFilter() -> String? {
        var ids: String!
        var index = 0
        let seenPosts = LocalUser.seenPosts
        //filter out seenPosts
        for (key, _ ) in seenPosts {
            
            if key == "_id" {
                continue
            }
            else {
                ids = index > 0 ? "\(ids) and (_id != \(key))" : "(_id != \(key))"
            }
            index += 1
        }
        
        //filter out user matches
        for match in LocalUser.matches {
            
            ids = ids == nil ? "(_id != \(match.itemID))" : "\(ids) and (_id != \(match.itemID))"
            
        }
        
        //filter out user's ads
        for (_, value) in LocalUser.user.posts {
            ids = ids == nil ? "(_id != \(value))" : "\(ids) and (_id != \(value))"
        }
        
        //filter by category
        if GlobalItems.currentCategory != nil {
            ids = ids == nil ? GlobalItems.currentCategory : "\(ids) and (category = \(GlobalItems.currentCategory!))"
        }
        
        ids = ids == nil ? "(bought != 1)" : "\(ids) and (bought != 1)"

        return ids
    }
    
}






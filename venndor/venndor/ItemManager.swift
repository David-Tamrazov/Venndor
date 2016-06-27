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
        item.getStringsFromImages(item.photos!)
        let params = ["name": item.name, "details": item.details, "owner": item.owner, "photoStrings": item.photoStrings] as JSON

        RESTEngine.sharedEngine.addItemToServerWithDetails(params,
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    item.id = id as! String
                    RESTEngine.sharedEngine.altAddItemImagesById(item.id, images: item.photos!,
                        success: { response in
                        },failure: { error in })
                }
                
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func retrieveItem(id: String, completionHandler: (Item?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemById(id,
            success: { response in
                if let response = response {
                    let item = Item(json: response)
                    completionHandler(item, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMultipleItems(count: Int, filter: String?, completionHandler: ([Item]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemsFromServer(count, filter: filter,
            success: { response in
                if let response = response, result = response["resource"] {
                    var itemsArray = [Item]()
                    let arr = result as! NSArray
                    for data in arr {
                        let data = data as! JSON
                        let item = Item(json: data)
                        item.getImagesFromStrings(item.photoStrings)
                        itemsArray.append(item)
                    }
                    completionHandler(itemsArray, nil)
                }
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
}






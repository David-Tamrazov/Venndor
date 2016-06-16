//
//  RESTEngine.swift
//  SampleAppSwift
//
//  Created by Timur Umayev on 1/8/16.
//  Copyright © 2016 dreamfactory. All rights reserved.
//

import UIKit

let kAppVersion = "1.0.1"

// change kApiKey and kBaseInstanceUrl to match your app and instance

// API key for your app goes here, see apps tab in admin console
private let kApiKey = "ed76c96fa75228ffc12fd2d14f0394ea0077f792cb27e95a469cbea640d986b2"
private let kBaseInstanceUrl = "http://ec2-52-53-217-174.us-west-1.compute.amazonaws.com/api/v2"
private let kDbServiceName = "venndor/_table"
private let kContainerName = "item_images"



typealias SuccessClosure = (JSON?) -> Void
typealias ErrorClosure = (NSError) -> Void

extension NSError {
    
    var errorMessage: String {
        if let errorMessage = self.userInfo["error"]?["message"] as? String {
            return errorMessage
        }
        return "Unknown error occurred"
    }
}

/**
 Routing to different type of API resources
 */
enum Routing {
    case User(resourseName: String)
    case Service(tableName: String)
    case ResourceFolder(folderPath: String)
    case ResourceFile(folderPath: String, fileName: String)
    
    var path: String {
        switch self {
            //rest path for request, form is <base instance url>/api/v2/user/resourceName
        case let .User(resourceName):
            return "\(kBaseInstanceUrl)/user/\(resourceName)"
            
            //rest path for request, form is <base instance url>/api/v2/<serviceName>/<tableName>
        case let .Service(tableName):
            return "\(kBaseInstanceUrl)/\(kDbServiceName)/\(tableName)"
            
            // rest path for request, form is <base instance url>/api/v2/files/container/<folder path>/
        case let .ResourceFolder(folderPath):
            return "\(kBaseInstanceUrl)/files/\(kContainerName)/\(folderPath)/"
            
            //rest path for request, form is <base instance url>/api/v2/files/container/<folder path>/filename
        case let .ResourceFile(folderPath, fileName):
            return "\(kBaseInstanceUrl)/files/\(kContainerName)/\(folderPath)/\(fileName)"
        }
    }
}

final class RESTEngine {
    static let sharedEngine = RESTEngine()
    
    let headerParams: [String: String] = {
        let dict = ["X-DreamFactory-Api-Key": kApiKey]
        return dict
    }()
    
    /*
    var sessionHeaderParams: [String: String] {
        var dict = headerParams
        dict["X-DreamFactory-Session-Token"] = sessionToken
        return dict
    }
    */
    
    private let api = NIKApiInvoker.sharedInstance
    
    private init() {
    }
    
    private func callApiWithPath(restApiPath: String, method: String, queryParams: [String: AnyObject]?, body: AnyObject?, headerParams: [String: String]?, success: SuccessClosure?, failure: ErrorClosure?) {
        api.restPath(restApiPath, method: method, queryParams: queryParams, body: body, headerParams: headerParams, contentType: "application/json", completionBlock: { (response, error) -> Void in
            if let error = error where failure != nil {
                failure!(error)
            } else if let success = success {
                success(response)
            }
        })
    }
    
    //MARK: - User methods
    
    func registerUser(email: String, firstName: String, lastName: String, age: Int, success: SuccessClosure, failure: ErrorClosure) {
        
        //login after signup
        let queryParams: [String: AnyObject] = ["login": "1"]
        let requestBody: [String: AnyObject] = ["email": email,
            "first_name": firstName,
            "last_name": firstName,
            "age": age]
        print("\(requestBody)")
        
        callApiWithPath(Routing.Service(tableName: "users").path, method: "POST", queryParams: queryParams, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Get a single user from the server
     */
    func getUserWithId(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // create filter to get info only for this contact
        let queryParams: [String: AnyObject] = ["filter": "_id=\(id)"]
        
        callApiWithPath(Routing.Service(tableName: "users").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }

    /**
     Remove user from server
     */
    func removeUserWithId(id: String, success: SuccessClosure, failure: ErrorClosure) {
        // remove user by user ID
        removeImageFolderWithId(id, success: { _ in
            
            let queryParams: [String: AnyObject] = ["filter": "_id=\(id)"]
            
            self.callApiWithPath(Routing.Service(tableName: "users").path, method: "DELETE", queryParams: queryParams, body: nil, headerParams: self.headerParams, success: success, failure: failure)
            
            }, failure: failure)
    }
    
    
    /**
     Update an existing contact info with the server
     */
    func updateUserWithId(id: String, info: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        let requestBody: [String: AnyObject] = info
        
        callApiWithPath("\(Routing.Service(tableName: "users").path)/\(id)", method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }

    
    //MARK: - Item methods
    
    /**
     Add an item to the server
    */
    
    func addItemToServerWithDetails(itemDetails: JSON, success: SuccessClosure, failure: ErrorClosure) {
        // need to create contact first, then can add contactInfo and group relationships
        
        let requestBody: [String: AnyObject] = ["resource": itemDetails]
        
        callApiWithPath(Routing.Service(tableName: "items").path, method: "POST", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Remove item from the server
    */
    
    func removeItemFromServerWithId(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        let queryParams: [String: AnyObject] = ["filter": "_id=\(id)"]
        
        callApiWithPath(Routing.Service(tableName: "items").path, method: "DELETE", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Get Item by its ID
     */
    
    func getItemWithId(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let queryParams: [String: AnyObject] = ["filter": "_id=\(id)"]
        
        callApiWithPath(Routing.Service(tableName: "items").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Get a whole mess of items
     */
    
    func getItemsFromServer(count: Int, success: SuccessClosure, failure: ErrorClosure) {
        let queryParameters: [String: AnyObject] = ["limit": count]
        callApiWithPath(Routing.Service(tableName: "items").path, method: "GET", queryParams: queryParameters, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Update items and users with the server
     */
    func updateItemWithId(itemId: String, itemDetails: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        // set the id of the contact we are looking at
        let requestBody: [String: AnyObject] = itemDetails
        
        callApiWithPath("\(Routing.Service(tableName: "items").path)/\(itemId)", method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    
    
    //MARK: - Image methods
    
    
    //so here we would provide the item id, and when we upload the image to our server we would need to set its path to ".../item_id"
    private func removeImageFolderWithId(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // delete all files and folders in the target folder
        let queryParams: [String: AnyObject] = ["force": "1"]
        
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "DELETE", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    
    /**
     Get profile image for user
    */
    func getProfileImageFromServerWithId(id: String, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // request a download from the file
        let queryParams: [String: AnyObject] = ["include_properties": "1",
            "content": "1",
            "download": "1"]
        
        callApiWithPath(Routing.ResourceFile(folderPath: "/\(id)", fileName: fileName).path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }

    
    /**
     Create item image on server
    */
    
    func addItemImageWithId(itemId: String, image: UIImage, imageName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // first we need to create folder, then image
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(itemId)").path, method: "POST", queryParams: nil, body: nil, headerParams: headerParams, success: { _ in
            
            self.putImageToFolderWithPath("\(itemId)", image: image, fileName: imageName, success: success, failure: failure)
            }, failure: failure)
    }
    
    //NEEDS REFACTORING- Investigate how to store it
    func putImageToFolderWithPath(folderPath: String, image: UIImage, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let file = NIKFile(name: fileName, mimeType: "application/octet-stream", data: imageData!)
        
        callApiWithPath(Routing.ResourceFile(folderPath: folderPath, fileName: fileName).path, method: "POST", queryParams: nil, body: file, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Fetch images for an item on the server
    */
    func getImageListFromServerWithItemId(itemId: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // only want to get files, not any sub folders
        let queryParams: [String: AnyObject] = ["include_folders": "0",
            "include_files": "1"]
        
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(itemId)").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
}

//
//  UserManager.swift
//  Testing- Backend
//
//  Created by David Tamrazov on 2016-06-17.
//  Copyright © 2016 David Tamrazov. All rights reserved.
//

import Foundation

enum UpdateType {
    case Ads()
    case Rating()
    case Matches()
}

struct UserManager {
    
    static let globalManager = UserManager() 

    func createUser(first: String, last: String, email: String, gender: String, ageRange: String, pushID: String, completionHandler: (User?, ErrorType?) -> ()) {
        
        var params: JSON =
            ["first_name": "\(first)",
             "last_name": "\(last)",
             "email": email,
             "phoneNumber": LocalUser.phoneNumber,
             "gender": gender,
             "ageRange": ageRange,
             "profilePictureURL": LocalUser.profilePictureURL,
             "facebookID": LocalUser.facebookID,
             "pushID": pushID,
             "university": "",
             "howTheyFoundVenndor": "",
             "rating": 0.0,
             "nuMatches": 0,
             "nuItemsSold": 0,
             "nuItemsBought": 0,
             "nuSwipesLeft": 0,
             "nuSwipesRight": 0,
             "nuSwipesTotal": 0,
             "nuPosts": 0,
             "nuVisits": 1,
             "moneySaved": 0,
             "mostRecentAction": "Created Account.",
             "timeOnAppPerSession": [String:AnyObject](),
             "timePerController": ["LoginViewController": 0.0, "BrowseViewController": 0.0, "ProfilePageViewController": 0.0, "PostViewController": 0.0, "SettingsViewController": 0.0, "MyPostsViewController": 0.0, "MyMatchesViewController": 0.0, "OfferViewController": 0.0, "DeleteViewController": 0.0, "PopUpViewController": 0.0, "ItemInfoViewController":0.0],
             "posts": [String:AnyObject](),
             "soldItems": [String:AnyObject](),
             "matches": [String:AnyObject](),
             "boughtItems": [String:AnyObject]()]
        
        RESTEngine.sharedEngine.registerUser(params,
            success: { response in
                
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    params["_id"] = id
                    let user = User(json: params)
                    completionHandler(user, nil)
                }
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    
    func retrieveUserById(id: String, completionHandler: (User?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getUserById(id,
            success: { response in
                
                //deconstruct the response into a "results" array
                if let response = response {
                    let data = response as JSON
                    //if the array is empty, then the user does not exist in the database. Return nil
                    let  user = User(json: data)
                    completionHandler(user, nil)
                    
                }
            }, failure: { error in
                completionHandler(nil, error)
                
        })
    }
    
    func retrieveUserByEmail(email: String, completionHandler: (User?, ErrorType?) ->() ) {
        RESTEngine.sharedEngine.getUserByEmail(email,
            success: { response in
               
                if let response = response, result = response["resource"] {
                    let info = result as! NSArray
                    if (info.count>0) {
                        let userData = info[0]
                        let user = User(json: userData as! JSON)
                        completionHandler(user, nil)
                    } else {
                        completionHandler(nil, nil)
                    }
                }
           
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveUserByFacebookID(fbID: String, completionHandler: (User?, ErrorType?) ->() ) {

        RESTEngine.sharedEngine.getUserByFacebookID(fbID,
            success: { response in
                                                
               if let response = response, result = response["resource"] {
                  let info = result as! NSArray
                
                  if (info.count>0) {
                    
                    let userData = info[0]
                    let user = User(json: userData as! JSON)
                    completionHandler(user, nil)
                    
                  }
                  
                  else {
                       completionHandler(nil, nil)
                    }
                }
                                                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMultipleUsers(filter: String, completionHandler: ([User]?, ErrorType?) -> ()) {
        RESTEngine.sharedEngine.getUsersByIds(filter,
            success: { response in
                if let response = response, result = response["resource"] {
                    var usersArray = [User]()
                    let arr = result as! NSArray
                    for data in arr {
                        let data = data as! JSON
                        let user = User(json: data)
                        usersArray.append(user)
                    }
                    completionHandler(usersArray, nil)
                }

            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func deleteUserById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.removeUserById(id,
            success: { response in
                completionHandler(nil)
            }, failure: {error in
                completionHandler(error)
        })
    }
    
    func updateUserById(id: String, update: [String:AnyObject], completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.updateUserById(id, info: update,
            success: { response in
                print("Succesfully updated the user.")
                completionHandler(nil)
            } , failure: { error in
                completionHandler(error)
        })
    }
    
    func updateMultipleUsers(update: [JSON], completionHandler:(ErrorType?) -> ()) {
        RESTEngine.sharedEngine.updateUsers(update,
            success: { response in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func updateLocalUserMetrics() {
        let update: [String:AnyObject] = ["nuItemsSold": LocalUser.user.nuItemsSold, "nuItemsBought": LocalUser.user.nuItemsBought, "nuSwipesLeft": LocalUser.user.nuSwipesLeft, "nuSwipesRight": LocalUser.user.nuSwipesRight, "nuSwipesTotal": LocalUser.user.nuSwipesTotal, "nuPosts": LocalUser.user.nuPosts, "nuVisits": LocalUser.user.nuVisits, "mostRecentAction": LocalUser.user.mostRecentAction, "timeOnAppPerSession": LocalUser.user.timeOnAppPerSession, "timePerController": LocalUser.user.timePerController, "soldItems": LocalUser.user.soldItems, "boughtItems": LocalUser.user.boughtItems]
        
        updateUserById(LocalUser.user.id, update: update) { error in
            guard error == nil else {
                print("Error updating user from background: \(error)")
                return
            }
            print("Succesfully updated local user's metrics.")
        }
    }
}
































//
//  ViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-07.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension UIViewController {
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    let loginButton : FBSDKLoginButton = FBSDKLoginButton()
//    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    @IBAction func loginButton2(sender: UIButton){
        loginButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("Already logged in")
            fetchProfile()
            self.performSegueWithIdentifier("showNew", sender: self)
        }
        else
        {
            print("not logged in")
//            self.view.addSubview(loginButton)
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
        }
        
    }
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {(
            connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            if let email = result["email"] as? String {
                currentUser = email
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil
        {
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                loginButton.hidden = true
                print("Login complete")
                fetchProfile()
                self.performSegueWithIdentifier("showNew", sender: self)
            }
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    //FACEBOOK LOGIN DELEGATES
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    
}

//
//  NotificationsViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class NotificationsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add lable for the title, NEEDS REFACTORING
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Notifications"
        self.view.addSubview(label)
        
        //add the generic views of each page ie. header and side menu
        addHeader()
        sideMenuGestureSetup()
    }
    
}
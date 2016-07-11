//
//  PopoverViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-07-08.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

import UIKit
import QuartzCore

class PopoverViewController : UIViewController {
    
    var screenSize = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    func setupBackground() {
        self.view.frame = CGRectMake(screenSize.width*0.3, screenSize.height*0.3, screenSize.width*0.4, screenSize.height*0.2)
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
    }
    
    func showInView(aView: UIView!)
    {
        aView.addSubview(self.view)
        self.showAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func closePopup(sender: AnyObject) {
        self.removeAnimate()
    }
}
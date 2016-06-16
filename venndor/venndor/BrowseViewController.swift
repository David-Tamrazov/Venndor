//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    
    var miniMatches: UIButton!
    var menuTransitionManager = MenuTransitionManager()
    let fadeOut = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColorFromHex(0xe6f2ff, alpha: 1)
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
        draggableBackground.insertSubview(backgroundImage, atIndex: 0)
        
        
        //add the header
        let headerView: HeaderView = HeaderView(frame: self.view.frame)
        headerView.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        headerView.categoryButton.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
        
        //MiniMyMatches button at bottom of browse.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let miniMatchesImage = UIImage(named: "ic_menu_white.png");
        miniMatches = UIButton(type: UIButtonType.Custom) as UIButton
        miniMatches.frame = CGRectMake(screenSize.width*0.435, screenSize.height*0.91, screenSize.width*0.13, screenSize.width*0.13)
        miniMatches.layer.cornerRadius = 0.5 * miniMatches.bounds.size.width
        miniMatches.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        miniMatches.setImage(miniMatchesImage, forState: .Normal)
        miniMatches.tag = 1
        self.view.addSubview(miniMatches)
        miniMatches.addTarget(self, action: "showAlert:", forControlEvents: UIControlEvents.TouchUpInside)

        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 100
            revealViewController().rearViewRevealWidth = 170
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        let subViews = self.view.subviews
        for subView in subViews {
            if subView == fadeOut {
                subView.removeFromSuperview()
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAlert(sender: UIButton) {
        print("buttonpress")
        self.performSegueWithIdentifier("MiniMatchSegue", sender: self)
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MiniMatchSegue" {
            let MiniMatchViewController = segue.destinationViewController as! MiniMyMatchesViewController
            fadeOut.frame = self.view.frame
            fadeOut.backgroundColor = UIColorFromHex(0xFFFFFF, alpha: 0.6)
            view.addSubview(fadeOut)
            MiniMatchViewController.transitioningDelegate = self.menuTransitionManager
        }
    }

    
}


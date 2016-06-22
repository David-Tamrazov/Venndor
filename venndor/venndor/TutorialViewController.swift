//
//  TutorialViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var startButton: UIButton!
    @IBAction func goToBrowse(sender: UIButton) {
        self.performSegueWithIdentifier("goBrowse", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
        textView.textAlignment = .Center
        textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
        textView.textColor = .blackColor()
        self.startButton.layer.cornerRadius = 4.0
        //3
        let imgOne = UIImageView(frame: CGRectMake(0, 0,scrollViewWidth, scrollViewHeight))
        imgOne.image = UIImage(named: "slide1")
        let imgTwo = UIImageView(frame: CGRectMake(scrollViewWidth, 0,scrollViewWidth, scrollViewHeight))
        imgTwo.image = UIImage(named: "slide2")
        let imgThree = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0,scrollViewWidth, scrollViewHeight))
        imgThree.image = UIImage(named: "slide3")
        let imgFour = UIImageView(frame: CGRectMake(scrollViewWidth*3, 0,scrollViewWidth, scrollViewHeight))
        imgFour.image = UIImage(named: "slide4")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        //4
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.decelerationRate = 0.1
        self.scrollView.delaysContentTouches = true
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            setButtonAlphaZero()
        }else if Int(currentPage) == 1{
            textView.text = "I write mobile tutorials mainly targeting iOS"
            setButtonAlphaZero()
        }else if Int(currentPage) == 2{
            textView.text = "And sometimes I write games tutorials about Unity"
            setButtonAlphaZero()
        }else{
            textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        }
        for x in 0...3 {
            if x == Int(currentPage) {
                let xOffset = CGPointMake(pageWidth*CGFloat(x), 0);
                self.scrollView.setContentOffset(xOffset, animated: true)
            }
        }
        
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            setButtonAlphaZero()
        }else if Int(currentPage) == 1{
            textView.text = "I write mobile tutorials mainly targeting iOS"
            setButtonAlphaZero()
        }else if Int(currentPage) == 2{
            textView.text = "And sometimes I write games tutorials about Unity"
            setButtonAlphaZero()
        }else{
            textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        }
        for x in 0...3 {
            if x == Int(currentPage) {
                let xOffset = CGPointMake(pageWidth*CGFloat(x), 0);
                self.scrollView.setContentOffset(xOffset, animated: true)
            }
        }
        
    }
    func setButtonAlphaZero() -> Void {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.startButton.alpha = 0
        })
    }

    
}
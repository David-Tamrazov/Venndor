//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPopoverPresentationControllerDelegate, DraggableViewDelegate {
    
    var allCards: [DraggableView]!
    var itemList: [Item]!
    
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.7
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    var MAX_BUFFER_SIZE: Int!
    
    var cardsLoadedIndex: Int!
    var currentCardIndex: Int!
    var loadedCards: [DraggableView]!
    var currentCategory: String!
    var itemName: UILabel!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var miniMatches: UIButton!
    var menuTransitionManager = MenuTransitionManager()
    let fadeOut = UIView()
    var headerView: HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        
        let globalItems = GlobalItems()
        
        globalItems.loadNextItem()
        // Do any additional setup after loading the view, typically from a nib.	
//        let user = LocalUser.user
//        let items = GlobalItems.items
        
        setupView()
        setupItemInfo()
        
        //MiniMyMatches button at bottom of browse.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonSize = CGRect(x: screenSize.width*0.435, y: screenSize.height*0.91, width: screenSize.width*0.13, height: screenSize.width*0.13)
        miniMatches = makeImageButton("ic_menu_white.png", frame: buttonSize, target: "showAlert:", tinted: false, circle: true, backgroundColor: 0x3498db, backgroundAlpha: 1)
        self.view.addSubview(miniMatches)
        
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        addHeader()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "toOfferScreen") {
//            let ovc = segue.destinationViewController as! OfferViewController
////            ovc.backgroundImage: UIColor = 
//            
//        }
//    }
    
    func setupView() {
        self.view.backgroundColor = UIColorFromHex(0xe6f2ff, alpha: 1)
        MAX_BUFFER_SIZE = GlobalItems.items.count
        itemList = []
        allCards = []
        loadedCards = []
        currentCardIndex = 0
        cardsLoadedIndex = 0
        loadCards(GlobalItems.items)
    }
    
    func showAlert(sender: UIButton) {
        
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let rect = CGRectMake(-10, 0, alertController.view.bounds.size.width, 165.0)
        let customView = UIView(frame: rect)
        let customViewTwo = UIView(frame: CGRect(x: -10, y: 125, width: alertController.view.bounds.size.width+10, height: 75))
        customViewTwo.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)

        let arrowView = UIView(frame: CGRect(x: (alertController.view.bounds.size.width)/2-23, y: 145, width: 30, height: 30))
        arrowView.backgroundColor = UIColor(patternImage: UIImage(named: "ic_keyboard_arrow_down_white.png")!)

        customView.backgroundColor = UIColorFromHex(0xe6e6e6)
        
        customView.layer.cornerRadius = 15

        alertController.view.addSubview(customView)
        alertController.view.addSubview(customViewTwo)
        alertController.view.addSubview(arrowView)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
        
    }
    
    //functions to create dragable views
    
    func createDraggableViewFromItem(item: Item) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT), item: item)
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.information.text = item.name
        draggableView.delegate = self
        return draggableView
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2.8, CARD_WIDTH, CARD_HEIGHT), item: GlobalItems.items[index])
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.information.text = GlobalItems.items[index].name
        draggableView.delegate = self
        return draggableView
    }
    
    //functions to create item information
    
    func updateItemInfo() {
        if currentCardIndex < itemList.count {
            itemName.text = itemList[currentCardIndex].name
        }
        
    }
    
    func setupItemInfo() {
        let itemInfo = UIView(frame: CGRect(x: (self.view.frame.size.width - CARD_WIDTH)/2, y: (self.view.frame.size.height - CARD_HEIGHT)/2.8 + CARD_HEIGHT, width: CARD_WIDTH, height: self.view.frame.height*0.1))
        itemInfo.backgroundColor = UIColor.whiteColor()
        itemInfo.layer.cornerRadius = 20
        itemInfo.layer.masksToBounds = true
        itemName = UILabel(frame: CGRect(x: itemInfo.frame.width*0.05, y: itemInfo.frame.height*0.2, width: itemInfo.frame.width, height: itemInfo.frame.height*0.6))
        itemInfo.addSubview(itemName)
        updateItemInfo()
        self.view.addSubview(itemInfo)
    }
    
    //Dragable view delegate functions
    
    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
//        loadedCards.append(allCards[0])
        nextCard()
        updateItemInfo()
        loadAnotherCard()
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
//        loadedCards.append(allCards[0])
        nextCard()
        updateItemInfo()
        loadAnotherCard()
    }
    
    func nextCard() {
        if loadedCards.count > 1 {
            currentCardIndex = currentCardIndex + 1
            self.view.insertSubview(loadedCards[cardsLoadedIndex - currentCardIndex - 1], belowSubview: loadedCards[cardsLoadedIndex - currentCardIndex - 2])
        }
        
    }
    
    //loading cards
    
    func loadAnotherCard() -> Void {
        let itemManager = ItemManager()
        itemManager.retrieveMultipleItems(1, offset: cardsLoadedIndex, filter: GlobalItems.currentCategory) { items, error in
            guard error == nil else {
                print("Error retrieving items from server: \(error)")
                return
            }
            
            if items != nil {
                let tempItem = items!
                
                //check that item is returned before creating slide to avoid null pointer exceptions
                if tempItem.count > 0 {
//                    print ("\(tempItem[0].id)")
                    self.itemList.append(tempItem[0])
                    let newCard: DraggableView = self.createDraggableViewFromItem(tempItem[0])
                    self.allCards.append(newCard)
                    self.loadedCards.append(newCard)
                    self.cardsLoadedIndex = self.cardsLoadedIndex + 1
                }
            }
        }
        print("load another")
    }
    
    func loadCards(items: [Item]) -> Void {
        if items.count > 0 {
            let numLoadedCardsCap = items.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : items.count
            for var i = 0; i < items.count; i++ {
                itemList.append(items[i])
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            while cardsLoadedIndex < loadedCards.count {
                if cardsLoadedIndex == 0 {
                    self.view.addSubview(loadedCards[cardsLoadedIndex])
                }
                else {
                    self.view.insertSubview(loadedCards[cardsLoadedIndex], belowSubview: loadedCards[cardsLoadedIndex - 1])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
            
//            for var i = 0; i < loadedCards.count; i++ {
//                if i > 0 {
//                    self.view.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
//                } else {
//                    self.view.addSubview(loadedCards[i])
//                }
//                cardsLoadedIndex = cardsLoadedIndex + 1
//            }
        }
        print("load cards")
    }

}


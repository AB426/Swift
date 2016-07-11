//
//  DishAddOnView.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 19..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

public class DishAddOnView: UIView, CheckboxDelegate {

    private var menuButton: UIButton!
    private var backgroundView: UIView!
    private var isShown: Bool!
    private var detailView: UIView!
    public var detailScroll: UIScrollView!
    
    var addOns : NSArray!
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    var cartDel: UIButton!
    var cartAdd: UIButton!
    
    var amountList : Array<UILabel> = []
    var quantities : NSMutableDictionary = NSMutableDictionary()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(aView: UIView!, title: String) {
        // Set frame
        let frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 352) / 736)
        
        super.init(frame:frame)
        
        amountList = []
        
        let window = UIApplication.sharedApplication().keyWindow!
        let detailViewBounds = window.bounds
        
        // Set up DropdownMenu
        self.detailView = UIView(frame: CGRectMake(detailViewBounds.origin.x, 0, detailViewBounds.width, (screen.size.height * 352) / 736))
        self.detailView.clipsToBounds = true
        self.detailView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Init background view (under table view)
        self.backgroundView = UIView(frame: CGRectMake(detailViewBounds.origin.x, 0, detailViewBounds.width, (screen.size.height * 352) / 736))
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Add background view & table view to container view
        self.detailView.addSubview(self.backgroundView)
        
        self.detailScroll =  UIScrollView(frame: CGRectMake(detailViewBounds.origin.x, 0, detailViewBounds.width, (screen.size.height * 352) / 736))
        self.detailScroll.scrollEnabled = true
        
        let subScript = UILabel(frame: CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 23) / 736, width: (screen.size.width * 368) / 414, height: (screen.size.height * 60) / 736))
        subScript.numberOfLines = 0
        subScript.text = "Please select the Add-On items from below\nto customize your order."
        subScript.textAlignment = .Center
        subScript.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        subScript.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        self.detailScroll.addSubview(subScript)
        
        addOns = (foodViewData.objectForKey("toppings") as? NSArray)!
        let subMenuHeight : CGFloat = (screen.size.height * 46) / 736
        var heightCount : CGFloat = 0
        if(addOns.count > 0) {
            for(var index = 0; index < addOns.count; ++index) {
                arrayForBool.addObject(false)
                let subMenu = UILabel()
                subMenu.frame = CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount), width: (screen.size.width * 170) / 414, height: subMenuHeight)
                subMenu.text = addOns[index].objectForKey("name") as? String
                subMenu.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                subMenu.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
                self.detailScroll.addSubview(subMenu)
                
                let subMenuPrice = UILabel()
                subMenuPrice.frame = CGRect(x: (screen.size.width * 200) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount), width: (screen.size.width * 70) / 414, height: subMenuHeight)
                subMenuPrice.text = (addOns[index].objectForKey("price") as! Double).format(someDoubleFormat) + "KD"
                subMenuPrice.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                subMenuPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
                self.detailScroll.addSubview(subMenuPrice)
                
                let cartAmount = UILabel()
                cartAmount.frame = CGRect(x: (screen.size.width * 326) / 414, y: (screen.size.height * 100) / 736 + (subMenuHeight * heightCount), width: (screen.size.width * 38) / 414, height: (screen.size.height * 34) / 736)
                cartAmount.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                cartAmount.font = UIFont(name: lato, size: (screen.size.width * 22) / 414)
                cartAmount.backgroundColor = UIColor.clearColor()
                cartAmount.text = "0"
                cartAmount.textAlignment = .Center
                self.detailScroll.addSubview(cartAmount)
                
                amountList.append(cartAmount)
                quantities.setValue(0, forKey: (addOns[index].objectForKey("name") as? String)!)
                
                cartDel = UIButton()
                cartDel.frame = CGRect(x: (screen.size.width * 299) / 414, y: (screen.size.height * 105) / 736 + (subMenuHeight * heightCount), width: (screen.size.width * 27) / 414, height: (screen.size.height * 27) / 736)
                cartDel.backgroundColor = UIColor.clearColor()
                cartDel.setBackgroundImage(UIImage(named: "icon_minuson"), forState: UIControlState.Normal)
                cartDel.addTarget(self, action: "changeDelQuantity:", forControlEvents: .TouchUpInside)
                cartDel.tag = index
                self.detailScroll.addSubview(cartDel)
                
                cartAdd = UIButton()
                cartAdd.frame = CGRect(x: (screen.size.width * 364) / 414, y: (screen.size.height * 105) / 736 + (subMenuHeight * heightCount), width: (screen.size.width * 27) / 414, height: (screen.size.height * 27) / 736)
                cartAdd.backgroundColor = UIColor.clearColor()
                cartAdd.setBackgroundImage(UIImage(named: "icon_pluson"), forState: UIControlState.Normal)
                cartAdd.addTarget(self, action: "changeAddQuantity:", forControlEvents: .TouchUpInside)
                cartAdd.tag = index
                self.detailScroll.addSubview(cartAdd)
                
                let line = UIView()
                line.frame = CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * (heightCount+1)), width: (screen.size.width * 369) / 414, height: 1)
                line.backgroundColor = UIColorFromHex(0x444444, alpha: 1.0)
                self.detailScroll.addSubview(line)
                
                heightCount++
            }
            
            self.detailScroll.contentSize = CGSizeMake(screen.size.width, (subMenuHeight + subScript.frame.height + (subMenuHeight * heightCount) + ((screen.size.height * 100) / 736)))
        }
        
        
        self.detailView.addSubview(detailScroll)
        self.backgroundView.alpha = 0.85
        self.addSubview(self.detailView)
        
        let shadow = UIImageView(image: UIImage(named: "shadow_scroll"))
        shadow.frame = CGRect(x: 0, y: (self.detailView.frame.size.height * 248) / 352, width: self.detailView.frame.size.width, height: (self.detailView.frame.size.height * 104) / 352)
        self.detailView.addSubview(shadow)
        
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: (self.detailView.frame.size.width * 298) / 414, y: (self.detailView.frame.size.height * 290) / 352, width: (self.frame.size.width * 37) / 414, height: (self.detailView.frame.size.height * 37) / 352)
        closeButton.setBackgroundImage(UIImage(named: "icon_x"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "hideView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.detailView.addSubview(closeButton)
        
        let selectButton = UIButton()
        selectButton.frame = CGRect(x: (self.detailView.frame.size.width * 350) / 414, y: (self.detailView.frame.size.height * 290) / 352, width: (self.detailView.frame.size.width * 37) / 414, height: (self.detailView.frame.size.height * 37) / 352)
        selectButton.setBackgroundImage(UIImage(named: "icon_check"), forState: UIControlState.Normal)
        selectButton.addTarget(self, action: "confirm:", forControlEvents: UIControlEvents.TouchUpInside)
        self.detailView.addSubview(selectButton)
        
        self.detailView.hidden = true
    }
    
    public func showView() {
        self.detailView.hidden = false
    }
    
    func hideView(sender : UIButton) {
        
        self.detailView.hidden = true
        self.removeFromSuperview()
    }
    
    func changeAddQuantity(sender: AnyObject?) {
        var quantity = quantities.objectForKey((addOns[sender!.tag].objectForKey("name") as? String)!) as! Int
        ++quantity
        let amount = amountList[sender!.tag]
        amount.text = quantity.description
        
        quantities.setValue(quantity, forKey: (addOns[sender!.tag].objectForKey("name") as? String)!)
    }
    
    func changeDelQuantity(sender: AnyObject?) {
        var quantity = quantities.objectForKey((addOns[sender!.tag].objectForKey("name") as? String)!) as! Int
        --quantity
        let amount = amountList[sender!.tag]
 
        if(quantity < 0) {
            quantity = 0
            
            let amount = amountList[sender!.tag]
            amount.text = quantity.description

        } else {
            amount.text = quantity.description
        }
        
        quantities.setValue(quantity, forKey: (addOns[sender!.tag].objectForKey("name") as? String)!)
    }
    
    func confirm(sender : UIButton) {
        
        toppingsList.removeAllObjects()

        for(var index = 0; index < addOns.count; ++index) {
            let toppings : NSMutableDictionary = NSMutableDictionary()
            toppings.setValue(index, forKey: "idx")
            toppings.setValue(addOns[index].objectForKey("name") as? String, forKey: "name")
            toppings.setValue((addOns[index].objectForKey("price")?.description)!, forKey: "price")
            toppings.setValue(quantities.objectForKey((addOns[index].objectForKey("name") as? String)!) as! Int, forKey: "quantity")
            
            toppingsList.addObject(toppings)
            
        }
        
        print(toppingsList)
        
        self.detailView.hidden = true
        self.removeFromSuperview()
    }

    func didSelectCheckbox(state: Bool, identifier: Int) {
        print("checkbox '\(identifier)' has state \(state)");
        
        arrayForBool.replaceObjectAtIndex(identifier, withObject: state)
        
    }
}

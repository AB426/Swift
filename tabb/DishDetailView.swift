//
//  DishDetailView.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 17..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

public class DishDetailView: UIView, CheckboxDelegate {

    private var backgroundView: UIView!
    private var isShown: Bool!
    public var detailView: UIView!
    
    public var detailScroll: UIScrollView!
    
    var ingredients : NSArray!
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(aView: UIView!, title: String) {
        // Set frame
        let frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 352) / 736)
        
        super.init(frame:frame)
        
        let window = UIApplication.sharedApplication().keyWindow!
        let detailViewBounds = window.bounds

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
        subScript.text = "Please check the ingredients to mark\nany of which you wish not to have."
        subScript.textAlignment = .Center
        subScript.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        subScript.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        self.detailScroll.addSubview(subScript)
        
        arrayForBool.removeAllObjects()
        
        ingredients = (foodViewData.objectForKey("excludes") as? NSArray)!
        let subMenuHeight : CGFloat = (screen.size.height * 46) / 736
        var heightCount : CGFloat = 0
        if(ingredients.count > 0) {
            for(var index = 0; index < ingredients.count; ++index) {
                arrayForBool.addObject(false)
                let subMenu = UILabel()
                subMenu.frame = CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount), width: (screen.size.width * 250) / 414, height: subMenuHeight)
                subMenu.text = ingredients[index].objectForKey("name") as? String
                subMenu.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                subMenu.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
                self.detailScroll.addSubview(subMenu)
                
                let lFrame = CGRectMake((screen.size.width * 360) / 414, (screen.size.height * 95) / 736 + (subMenuHeight * heightCount), (screen.size.width - ((screen.size.width * 381) / 414)), subMenuHeight)
                
                let lCheckbox = Checkbox(frame: lFrame, selected: false, checkValue: 1)
                lCheckbox.mDelegate = self
                lCheckbox.tag = index
                
                self.detailScroll.addSubview(lCheckbox)
                
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
    
    func updateDisplay() {
        
    }
    
    public func showView() {
        self.detailView.hidden = false
//        arrayForBool.removeAllObjects()
//        for(var index = 0; index < ingredients.count; ++index) {
//            arrayForBool.addObject(false)
//        }
    }
    
    func hideView(sender : UIButton) {
       
        self.detailView.hidden = true
        self.removeFromSuperview()
    }
    
    func confirm(sender : UIButton) {
        excludesList.removeAllObjects()
        var idx = 0
        for(var index = 0; index < ingredients.count; ++index) {
            if(arrayForBool.objectAtIndex(index).boolValue == true) {
                let excludes : NSMutableDictionary = NSMutableDictionary()
                excludes.setValue(idx, forKey: "idx")
                excludes.setValue(ingredients[index].objectForKey("name") as? String, forKey: "name")

                excludesList.addObject(excludes)
                
                ++idx
            }
        }
        
        self.detailView.hidden = true
        self.removeFromSuperview()
     }
    
    func didSelectCheckbox(state: Bool, identifier: Int) {
        print("checkbox '\(identifier)' has state \(state)");
        arrayForBool.replaceObjectAtIndex(identifier, withObject: state)
    }

}

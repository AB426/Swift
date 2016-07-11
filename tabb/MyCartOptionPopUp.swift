//
//  MyCartOptionPopUp.swift
//  tabb
//
//  Created by LeeDongMin on 1/4/16.
//  Copyright © 2016 LeeDongMin. All rights reserved.
//

import UIKit

class MyCartOptionPopUp: UIViewController {

    var message = UILabel()
    var popUp = UIView()
    
    var detailScroll: UIScrollView!
    
    var options : NSArray!
    var ingredients : NSArray!
    var addOns : NSArray!
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    var selectBoxs = Array<UIButton>()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        options = NSArray()
        ingredients = NSArray()
        addOns = NSArray()
        
        self.view.backgroundColor = UIColorFromHex(0x111111, alpha: 0.8)
        
    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool, items1 : NSArray, items2 : NSArray, items3 : NSArray) {
        options = items1
        ingredients = items2
        addOns = items3
        
        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        self.popUp = UIView()
        let screen: CGRect = UIScreen.mainScreen().bounds
        self.popUp.layer.shadowOpacity = 0.8
        self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.popUp.backgroundColor = UIColor.clearColor()
        self.popUp.frame = CGRectMake(0, 0,  menuWrapperBounds.width, menuWrapperBounds.height)
        
        detailScroll = UIScrollView()
        detailScroll.backgroundColor = UIColor.clearColor()
        detailScroll.frame = CGRectMake(0, (screen.size.height * 150) / 736, screen.size.width, (screen.size.height * 478) / 736)
        self.popUp.addSubview(detailScroll)
        
        let topImage = UIImageView(image: UIImage(named: "pop_top"))
        topImage.frame = CGRectMake((screen.size.width * 47) / 414, 0, (screen.size.width * 320) / 414, (screen.size.height * 124) / 736)
        detailScroll.addSubview(topImage)
        
        let contentView = UIView()
        contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 124) / 736, (screen.size.width * 320) / 414, (screen.size.height * 400) / 736)
        contentView.backgroundColor = UIColor.whiteColor()
        detailScroll.addSubview(contentView)
        
        let subScript = UILabel(frame: CGRect(x: (screen.size.width * 15) / 414, y: (screen.size.height * 17) / 736, width: (screen.size.width * 368) / 414, height: (screen.size.height * 30) / 736))
        subScript.numberOfLines = 0
        subScript.text = "The information contained in the food."
        subScript.textColor = UIColorFromHex(0x999999, alpha: 1.0)
        subScript.font = UIFont(name: latoBold, size: (screen.size.width * 12) / 414)
        contentView.addSubview(subScript)
        
        let scriptLine = UIView()
        scriptLine.frame = CGRectMake(0, (screen.size.height * 66) / 736, (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
        scriptLine.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        contentView.addSubview(scriptLine)
        
        var heightCount : CGFloat = 0
        let subMenuHeight : CGFloat = (screen.size.height * 46) / 736
        var subOriginY : CGFloat = 0
        
        if(ingredients.count > 0) {
            let optionTitleView = UIView()
            optionTitleView.frame = CGRectMake(0, scriptLine.frame.origin.y + scriptLine.frame.size.height, (screen.size.width * 320) / 414, (screen.size.height * 30) / 736)
            optionTitleView.backgroundColor = UIColorFromHex(0xf2f2f2, alpha: 1.0)
            contentView.addSubview(optionTitleView)
            
            let optionTitle = UILabel()
            optionTitle.frame = CGRectMake((screen.size.width * 15) / 414, (screen.size.height * 5) / 736, (screen.size.width * 320) / 414, (screen.size.height * 20) / 736)
            optionTitle.text = "Delete from Ingredients"
            optionTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            optionTitle.font = UIFont(name: latoBold, size: (screen.size.width * 11) / 414)
            optionTitleView.addSubview(optionTitle)
            
            let optionLine = UIView()
            optionLine.frame = CGRectMake(0, optionTitleView.frame.origin.y + optionTitleView.frame.size.height, (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
            optionLine.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
            contentView.addSubview(optionLine)
            
            subOriginY = optionLine.frame.origin.y + optionLine.frame.size.height

            for(var index=0; index<ingredients.count; index++) {
                arrayForBool.addObject(false)
                let subMenu = UILabel()
                subMenu.frame = CGRectMake((screen.size.width * 15) / 414, subOriginY + (subMenuHeight * heightCount), (screen.size.width * 200) / 414, subMenuHeight)
                subMenu.text = ingredients[index].objectForKey("name") as? String
                subMenu.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                subMenu.font = UIFont(name: lato, size: (screen.size.width * 11) / 414)
                contentView.addSubview(subMenu)
                
                let line = UIView()
                line.frame = CGRectMake(0, subOriginY + (subMenuHeight * (heightCount+1)), (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
                line.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
                contentView.addSubview(line)
                
                heightCount++
            }
        }
        
        if(subOriginY == 0) {
            subOriginY = scriptLine.frame.origin.y + scriptLine.frame.size.height
        }
        
        var addCount : CGFloat = 0
        if(addOns.count > 0) {
            let optionTitleView = UIView()
            optionTitleView.frame = CGRectMake(0, subOriginY + (subMenuHeight * heightCount) + (screen.size.height * 1) / 736, (screen.size.width * 320) / 414, (screen.size.height * 30) / 736)
            optionTitleView.backgroundColor = UIColorFromHex(0xf2f2f2, alpha: 1.0)
            contentView.addSubview(optionTitleView)
            
            let optionTitle = UILabel()
            optionTitle.frame = CGRectMake((screen.size.width * 15) / 414, (screen.size.height * 5) / 736, (screen.size.width * 320) / 414, (screen.size.height * 20) / 736)
            optionTitle.text = "Add-Ons"
            optionTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            optionTitle.font = UIFont(name: latoBold, size: (screen.size.width * 11) / 414)
            optionTitleView.addSubview(optionTitle)
            
            let optionLine = UIView()
            optionLine.frame = CGRectMake(0, optionTitleView.frame.origin.y + optionTitleView.frame.size.height, (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
            optionLine.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
            contentView.addSubview(optionLine)
            
            subOriginY = optionLine.frame.origin.y + optionLine.frame.size.height
            
            
            
            for(var index=0; index<addOns.count; index++) {
                arrayForBool.addObject(false)
                let subMenu = UILabel()
                subMenu.frame = CGRectMake((screen.size.width * 15) / 414, subOriginY + (subMenuHeight * addCount), (screen.size.width * 200) / 414, subMenuHeight)
                subMenu.text = addOns[index].objectForKey("name") as? String
                subMenu.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                subMenu.font = UIFont(name: lato, size: (screen.size.width * 11) / 414)
                contentView.addSubview(subMenu)
                
                
                
                let subPrice = UILabel()
                subPrice.frame = CGRectMake((screen.size.width * 215) / 414, subOriginY + (subMenuHeight * addCount), (screen.size.width * 60) / 414, subMenuHeight)
                subPrice.text = (addOns[index].objectForKey("price") as! Double).format(someDoubleFormat) + " KD"
                subPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                subPrice.font = UIFont(name: lato, size: (screen.size.width * 11) / 414)
                subPrice.textAlignment = .Right
                contentView.addSubview(subPrice)
                
                let subQty = UILabel()
                subQty.frame = CGRectMake((screen.size.width * 275) / 414, subOriginY + (subMenuHeight * addCount), (screen.size.width * 30) / 414, subMenuHeight)
                subQty.text = addOns[index].objectForKey("quantity")?.description
                subQty.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                subQty.font = UIFont(name: lato, size: (screen.size.width * 11) / 414)
                subQty.textAlignment = .Right
                contentView.addSubview(subQty)
                
                let line = UIView()
                line.frame = CGRectMake(0, subOriginY + (subMenuHeight * (addCount+1)), (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
                line.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
                contentView.addSubview(line)
                
                addCount++
                heightCount++
            }
        }

        var optionCount : CGFloat = 0
        
        if(addCount == 0) {
            addCount = heightCount
        }
        
        if(subOriginY == 0) {
            subOriginY = scriptLine.frame.origin.y + scriptLine.frame.size.height
        }
        
        if(options.count > 0) {
            let optionTitleView = UIView()
            optionTitleView.frame = CGRectMake(0, subOriginY + (subMenuHeight * addCount) + (screen.size.height * 1) / 736, (screen.size.width * 320) / 414, (screen.size.height * 30) / 736)
            optionTitleView.backgroundColor = UIColorFromHex(0xf2f2f2, alpha: 1.0)
            contentView.addSubview(optionTitleView)
            
            let optionTitle = UILabel()
            optionTitle.frame = CGRectMake((screen.size.width * 15) / 414, (screen.size.height * 5) / 736, (screen.size.width * 320) / 414, (screen.size.height * 20) / 736)
            optionTitle.text = "Option"
            optionTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            optionTitle.font = UIFont(name: latoBold, size: (screen.size.width * 11) / 414)
            optionTitleView.addSubview(optionTitle)
            
            let optionLine = UIView()
            optionLine.frame = CGRectMake(0, optionTitleView.frame.origin.y + optionTitleView.frame.size.height, (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
            optionLine.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
            contentView.addSubview(optionLine)
            
            subOriginY = optionLine.frame.origin.y + optionLine.frame.size.height
            
            
            
            for(var index=0; index<options.count; index++) {
                arrayForBool.addObject(false)
                let subMenu = UILabel()
                subMenu.frame = CGRectMake((screen.size.width * 15) / 414, subOriginY + (subMenuHeight * optionCount), (screen.size.width * 200) / 414, subMenuHeight)
                subMenu.text = options[index].objectForKey("name") as? String
                subMenu.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                subMenu.font = UIFont(name: lato, size: (screen.size.width * 11) / 414)
                contentView.addSubview(subMenu)
                
                let line = UIView()
                line.frame = CGRectMake(0, subOriginY + (subMenuHeight * (optionCount+1)), (screen.size.width * 320) / 414, (screen.size.height * 1) / 736)
                line.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
                contentView.addSubview(line)
                
                optionCount++
                heightCount++
            }
            
        }
        
        let close: UIButton = UIButton()
        
        close.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 674) / 736, (screen.size.width * 320) / 414, (screen.size.height * 54) / 736)
        close.setTitle("OK", forState: UIControlState.Normal)
        close.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        close.roundCorners(([.BottomLeft, .BottomRight]), radius: (screen.size.width * 3.5) / 414)
        close.clipsToBounds = true
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        detailScroll.addSubview(close)
        
        self.view.addSubview(self.popUp)
        
        window.addSubview(self.view)
        
        //위치 재조정
        if(addCount == 0 && optionCount == 0) {
            contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 124) / 736, (screen.size.width * 320) / 414, subOriginY + (subMenuHeight * heightCount))
        } else if(optionCount > 0) {
            contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 124) / 736, (screen.size.width * 320) / 414, subOriginY + (subMenuHeight * optionCount))
        } else {
            contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 124) / 736, (screen.size.width * 320) / 414, subOriginY + (subMenuHeight * addCount))
        }
        let button_y = (contentView.frame.height + contentView.frame.origin.y)
        
        print(subOriginY)
        print(addCount)
        print(optionCount)
        print(contentView.frame.size.height)
        
        close.frame = CGRectMake((screen.size.width * 47) / 414, button_y, (screen.size.width * 320) / 414, (screen.size.height * 54) / 736)
        
        let popUpHeight = button_y + (screen.size.height * 54) / 736
        
        if(popUpHeight > screen.size.height) {
            detailScroll.frame = CGRectMake(0, 0, screen.size.width, screen.size.height)
            detailScroll.contentSize = CGSize(width: contentView.frame.width, height: popUpHeight)
        } else {
            detailScroll.frame = CGRectMake(0, (screen.size.height - popUpHeight) / 2, screen.size.width, popUpHeight)
            detailScroll.contentSize = CGSize(width: contentView.frame.width, height: popUpHeight)
        }
        
        if animated
        {
            self.showAnimate()
        }
    }
    
    
    func showAnimate()
    {
        
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.15, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.15, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func close(sender: AnyObject?) {
        
        self.removeAnimate()
        
    }

}

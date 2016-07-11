//
//  DishNutritionView.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 19..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

public class DishNutritionView: UIView {

    private var menuButton: UIButton!
    private var backgroundView: UIView!
    private var isShown: Bool!
    private var detailView: UIView!
    private var detailScroll: UIScrollView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(aView: UIView!, title: String) {
        // Set frame
        let frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 352) / 736)
        
        super.init(frame:frame)
        
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
        
        let subScript = UILabel(frame: CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 23) / 736, width: (screen.size.width * 368) / 414, height: (screen.size.height * 30) / 736))
        subScript.numberOfLines = 0
        subScript.text = "NUTRITION FACTS per serving"
        subScript.textAlignment = .Center
        subScript.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        subScript.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        self.detailScroll.addSubview(subScript)
        
        let calories = UILabel(frame: CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 53) / 736, width: (screen.size.width * 220) / 414, height: (screen.size.height * 30) / 736))
        calories.numberOfLines = 0

        let x: AnyObject = foodViewData.objectForKey("calorie")!
        
        if let y = x as? String {
            calories.text = "CALORIES " + y
        } else {
            calories.text = "CALORIES 0Kcal"
        }
        calories.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        calories.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        self.detailScroll.addSubview(calories)
        
        let caloreisSub = UILabel(frame: CGRect(x: (screen.size.width * 266) / 414, y: (screen.size.height * 57) / 736, width: (screen.size.width * 125) / 414, height: (screen.size.height * 26) / 736))
        caloreisSub.numberOfLines = 0
        caloreisSub.text = ""
        caloreisSub.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        caloreisSub.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        caloreisSub.textAlignment = .Right
        self.detailScroll.addSubview(caloreisSub)
        
        /*
        성분함량 리스트를 위한 메소드
        전체 함량이 있고 그 하위로 여러가지 성분들이 있어서 for문을 돌려서 전부를 리스트 할 수 밖에 없었다.
        */
        let nutritionFacts : NSArray = (foodViewData.objectForKey("nutritionFacts") as? NSArray)!
        let subMenuHeight : CGFloat = (screen.size.height * 23) / 736
        var heightCount : CGFloat = 0   //타이틀 내용을 리스트 하기 위한 count
        var childHeightCount : CGFloat = 1  //서브 내용 리스트 하기 위한 count
        if(nutritionFacts.count > 0) {
            for(var index = 0; index < nutritionFacts.count; ++index) {
                --childHeightCount
                
                let line = UIView()
                line.frame = CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount) + (subMenuHeight * childHeightCount), width: (screen.size.width * 369) / 414, height: 1)
                line.backgroundColor = UIColorFromHex(0x444444, alpha: 1.0)
                self.detailScroll.addSubview(line)
                
                
                let subMenu = UILabel()
                subMenu.frame = CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount) + (subMenuHeight * childHeightCount), width: (screen.size.width * 250) / 414, height: subMenuHeight)
                subMenu.text = nutritionFacts[index].objectForKey("nutrient") as? String
                subMenu.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                subMenu.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                self.detailScroll.addSubview(subMenu)
                
                let subNutrition = UILabel()
                subNutrition.frame = CGRect(x: (screen.size.width * 311) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount) + (subMenuHeight * childHeightCount), width: (screen.size.width * 80) / 414, height: subMenuHeight)
                subNutrition.text = nutritionFacts[index].objectForKey("content") as? String
                subNutrition.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                subNutrition.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                subNutrition.textAlignment = .Right
                self.detailScroll.addSubview(subNutrition)
                
                ++childHeightCount
                
                if(nutritionFacts[index].objectForKey("child") is NSArray) {
                    
                    let subChilds : NSArray = (nutritionFacts[index].objectForKey("child") as? NSArray)!
                    
                    for(var indexChild = 0; indexChild < subChilds.count; ++indexChild) {
                        let childSubMenu = UILabel()
                        childSubMenu.frame = CGRect(x: (screen.size.width * 33) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount) + (subMenuHeight * childHeightCount), width: (screen.size.width * 240) / 414, height: subMenuHeight)
                        childSubMenu.text = subChilds[indexChild].objectForKey("nutrient") as? String
                        childSubMenu.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                        childSubMenu.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                        self.detailScroll.addSubview(childSubMenu)
                        
                        let childSubNutrition = UILabel()
                        childSubNutrition.frame = CGRect(x: (screen.size.width * 311) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount) + (subMenuHeight * childHeightCount), width: (screen.size.width * 80) / 414, height: subMenuHeight)
                        childSubNutrition.text = subChilds[indexChild].objectForKey("content") as? String
                        childSubNutrition.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                        childSubNutrition.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                        childSubNutrition.textAlignment = .Right
                        self.detailScroll.addSubview(childSubNutrition)
                        
                        ++childHeightCount
                    }
                    
                    
                }
                
                heightCount++
            }
            
            let line = UIView()
            line.frame = CGRect(x: (screen.size.width * 23) / 414, y: (screen.size.height * 95) / 736 + (subMenuHeight * heightCount) + (subMenuHeight * (childHeightCount - 1)), width: (screen.size.width * 369) / 414, height: 1)
            line.backgroundColor = UIColorFromHex(0x444444, alpha: 1.0)
            self.detailScroll.addSubview(line)
            
            self.detailScroll.contentSize = CGSizeMake(screen.size.width, (subMenuHeight + subScript.frame.height + (subMenuHeight * heightCount) + (subMenuHeight * (childHeightCount - 1)) + ((screen.size.height * 100) / 736)))
        }
        
        
        self.detailView.addSubview(detailScroll)
        self.backgroundView.alpha = 0.85
        self.addSubview(self.detailView)
        
        let shadow = UIImageView(image: UIImage(named: "shadow_scroll"))
        shadow.frame = CGRect(x: 0, y: (self.detailView.frame.size.height * 248) / 352, width: self.detailView.frame.size.width, height: (self.detailView.frame.size.height * 104) / 352)
        self.detailView.addSubview(shadow)
        
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: (self.detailView.frame.size.width * 350) / 414, y: (self.detailView.frame.size.height * 290) / 352, width: (self.frame.size.width * 37) / 414, height: (self.detailView.frame.size.height * 37) / 352)
        closeButton.setBackgroundImage(UIImage(named: "icon_x"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "hideView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.detailView.addSubview(closeButton)
        
        self.detailView.hidden = true
    }
    
    public func showView() {
        self.detailView.hidden = false
    }
    
    func hideView(sender : UIButton) {
        
        self.detailView.hidden = true
        self.removeFromSuperview()
        
    }


}

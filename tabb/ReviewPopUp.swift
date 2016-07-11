//
//  ReviewPopUp.swift
//  tabb
//
//  Created by LeeDongMin on 12/30/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class ReviewPopUp: UIViewController {

    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
    var starList = Array<UIImageView>()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool) {
        
        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        self.popUp = UIView()
        let screen: CGRect = UIScreen.mainScreen().bounds
        self.popUp.layer.shadowOpacity = 0.8
        self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.popUp.backgroundColor = UIColor.clearColor()
        self.popUp.frame = CGRectMake(0, 0,  menuWrapperBounds.width, menuWrapperBounds.height)
        
        popUpScrollView = UIScrollView()
        popUpScrollView.backgroundColor = UIColor.clearColor()
        popUpScrollView.frame = CGRectMake(0, 0, menuWrapperBounds.width, (screen.size.height * 623) / 736)
        self.popUp.addSubview(popUpScrollView)
        
        let reviewTitle = UILabel()
        reviewTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 26) / 736, (screen.size.width * 250) / 414, (screen.size.height * 20) / 736)
        reviewTitle.text = foodViewData.objectForKey("name") as? String
        reviewTitle.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        reviewTitle.backgroundColor = UIColor.clearColor()
        reviewTitle.font = UIFont(name: lato, size: (screen.size.width * 18 / 414))
        popUpScrollView.addSubview(reviewTitle)
        
        let close = UIButton()
        close.frame = CGRectMake((screen.size.width * 376) / 414, (screen.size.height * 18) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        close.setBackgroundImage(UIImage(named: "btn_x"), forState: .Normal)
        close.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        popUpScrollView.addSubview(close)
        
        
        let margin = (screen.size.height * 10) / 736
        let topViewHeight = (screen.size.height * 38) / 736
        var bottomViewHeight : CGFloat = 0
        let topView_y = (screen.size.height * 61) / 736
        var viewCount : CGFloat = 0
        
        var totalBottomHeight : CGFloat = 0
        
        var totalHeight : CGFloat = 0
        
        for(var index = 0; index < reviewList.count; ++index) {
            
            
            let topView = UIView()
            topView.frame = CGRectMake((screen.size.width * 11) / 414, topView_y + totalBottomHeight + (margin * viewCount) + (topViewHeight * viewCount), (screen.size.width * 392) / 414, topViewHeight)
            topView.backgroundColor = UIColor.whiteColor()
            popUpScrollView.addSubview(topView)
            
            viewBox(topView, value: 0xcccccc, border: (screen.size.width * 0.5) / 414, radius: 0)
            
            let reviewDate = UILabel()
            reviewDate.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 9) / 736, (screen.size.width * 80) / 414, (screen.size.height * 20) / 736)
            reviewDate.text = reviewList[index].objectForKey("created") as? String
            reviewDate.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            reviewDate.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            topView.addSubview(reviewDate)
            
            let reviewName = UILabel()
            reviewName.frame = CGRectMake((screen.size.width * 96) / 414, (screen.size.height * 6) / 736, (screen.size.width * 200) / 414, (screen.size.height * 26) / 736)
            reviewName.text = reviewList[index].objectForKey("writer") as? String
            reviewName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            reviewName.font = UIFont(name: latoBold, size: (screen.size.width * 18) / 414)
            reviewName.textAlignment = .Center
            reviewName.adjustsFontSizeToFitWidth = true
            topView.addSubview(reviewName)
            
            let grade_x = (screen.size.width * 296) / 414
            let gradeWidth = (screen.size.width * 17) / 414
            var count:CGFloat = 0
            for(var index = 0; index < 5; ++index) {
                let star = UIImageView(image: UIImage(named: "icon_star_off"))
                star.frame = CGRect(x: grade_x + (count * gradeWidth), y: (screen.size.height * 10) / 736, width: (screen.size.width * 17) / 414, height: (screen.size.height * 17) / 736)
                topView.addSubview(star)
                
                starList.append(star)
                
                count++
            }
            
            //grade
            let grade = reviewList[index].objectForKey("grade") as! Double
            
            gradeVisible(starList, grade: grade)
            
            let content: NSString = reviewList[index].objectForKey("content") as! NSString
            let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 15) / 414)])
            
            totalHeight += topView.frame.size.height
            
            bottomViewHeight = labelSize.height + (screen.size.height * 30) / 736
            
            totalBottomHeight += bottomViewHeight
            totalHeight += bottomViewHeight
            
            let bottomView = UIView()
            bottomView.frame = CGRectMake((screen.size.width * 11) / 414, topView.frame.origin.y + topViewHeight, (screen.size.width * 392) / 414, bottomViewHeight)
            bottomView.backgroundColor = UIColor.whiteColor()
            popUpScrollView.addSubview(bottomView)
            
            
            let reviewContent = UILabel()
            reviewContent.frame = CGRectMake((screen.size.width * 11) / 414, (bottomViewHeight - (labelSize.height + 10)) / 2, (screen.size.width * 370) / 414, labelSize.height + 10)
            reviewContent.text = content.description
            reviewContent.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            reviewContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            reviewContent.numberOfLines = 0
            reviewContent.textAlignment = .Left
            bottomView.addSubview(reviewContent)
            viewBox(bottomView, value: 0xcccccc, border: (screen.size.width * 0.5) / 414, radius: 0)
            
            ++viewCount;
        }
        
        print(totalHeight + (margin * viewCount))
        
        popUpScrollView.contentSize = CGSize(width: screen.size.width, height: totalHeight + (margin * viewCount) + (screen.size.height * 61) / 736)
        
        self.view.addSubview(self.popUp)
        
        aView.addSubview(self.view)

        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.15, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animateWithDuration(0.15, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func close(sender: AnyObject?) {
        self.removeAnimate()
    }

}

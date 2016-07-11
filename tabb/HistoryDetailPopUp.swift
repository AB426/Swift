//
//  HistoryDetailPopUp.swift
//  tabb
//
//  Created by LeeDongMin on 12/29/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class HistoryDetailPopUp: UIViewController {

    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
    var slider: UISlider!
    var gratitudeValue = UILabel()
    var gratitudeAmount = UILabel()
    var totalPrice = UILabel()
    var subTotal : Double!
    
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.9)
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
        popUpScrollView.frame = CGRectMake(0, 0, menuWrapperBounds.width, menuWrapperBounds.height)
        self.popUp.addSubview(popUpScrollView)
        
        
        let topImage = UIImageView(image: UIImage(named: "bill_top"))
        topImage.frame = CGRectMake((screen.size.width * 11) / 414, 20, (screen.size.width * 392) / 414, (screen.size.height * 19) / 736)
        popUpScrollView.addSubview(topImage)
        
        contentView = UIView()
        //크기를 가변으로 가야한다.
        contentView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 19) / 736 + 20, (screen.size.width * 392) / 414, (screen.size.height * 450) / 736)
        contentView.backgroundColor = UIColor.whiteColor()
        popUpScrollView.addSubview(contentView)
        
        let restaurantName = UILabel()
        restaurantName.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 15) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        restaurantName.text = historyDetailData.objectForKey("restaurantName") as? String
        restaurantName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        restaurantName.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        contentView.addSubview(restaurantName)
        
        let date = UILabel()
        date.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 35) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        date.text = (historyDetailData.objectForKey("day") as! String)
        date.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        date.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(date)
        
        let checkInTime = historyDetailData.objectForKey("checkInTime") as! String
        
        let checkInDate = UILabel()
        checkInDate.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 55) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        checkInDate.text = "CHECK IN " + checkInTime
        checkInDate.textColor = UIColorFromHex(0x999999, alpha: 1.0)
        checkInDate.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(checkInDate)
        
        let checkOutDate = UILabel()
        checkOutDate.frame = CGRectMake((screen.size.width * 140) / 414, (screen.size.height * 55) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        checkOutDate.text = "OUT " + (historyDetailData.objectForKey("checkOutTime") as! String)
        checkOutDate.textColor = UIColorFromHex(0x999999, alpha: 1.0)
        checkOutDate.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(checkOutDate)
        
        let otherNames = UILabel()
        otherNames.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 75) / 736, (screen.size.width * 300) / 414, (screen.size.height * 20) / 736)
        otherNames.text = historyDetailData.objectForKey("memberNames") as? String
        otherNames.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        otherNames.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(otherNames)
        
        let close = UIButton()
        close.frame = CGRectMake((screen.size.width * 354) / 414, (screen.size.height * 11) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        close.setBackgroundImage(UIImage(named: "btn_x2"), forState: .Normal)
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(close)
        
        let subView_y = (screen.size.height * 110) / 736 + 20
        let lineView_y = (screen.size.height * 48) / 736
        var count : CGFloat = 0
        let line1ImageHeight = (screen.size.height * 2) / 736
        
        let items = historyDetailData.objectForKey("items") as? NSArray
        
        for(var index = 0; index < items?.count; ++index) {
            
            let lineView = UIView()
            lineView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
            lineView.backgroundColor = UIColor.clearColor()
            contentView.addSubview(lineView)
            
            let historyTitle = UILabel()
            historyTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
            historyTitle.text = items![index].objectForKey("foodName") as? String
            historyTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            historyTitle.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            lineView.addSubview(historyTitle)
            
            let amount = items![index].objectForKey("amount") as! Double
            
            let historyPrice = UILabel()
            historyPrice.frame = CGRectMake((screen.size.width * 261) / 414, (screen.size.height * 13) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
            historyPrice.text = amount.format(someDoubleFormat) + "KD"
            historyPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            historyPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            historyPrice.textAlignment = .Right
            lineView.addSubview(historyPrice)
            
            //            let amount = splitItems[index].objectForKey("amount") as? Double
            //            total += amount!
            
            let line1Image = UIImageView(image: UIImage(named: "bill_line1"))
            line1Image.frame = CGRectMake(0, ((screen.size.height * 46) / 736) + subView_y + (lineView_y * count), (screen.size.width * 392) / 414, line1ImageHeight)
            contentView.addSubview(line1Image)
            
            ++count
        }
        
        
        let subView = UIView()
        subView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        subView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(subView)
        
        let subTitle = UILabel()
        subTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        subTitle.text = "SUBTOTAL"
        subTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        subTitle.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        subView.addSubview(subTitle)
        
        let subPrice = UILabel()
        subPrice.frame = CGRectMake((screen.size.width * 261) / 414, (screen.size.height * 13) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        subPrice.text = (historyDetailData.objectForKey("subTotal") as! Double).format(someDoubleFormat) + "KD"
        subPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        subPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        subPrice.textAlignment = .Right
        subView.addSubview(subPrice)
        
        let line2Image = UIImageView(image: UIImage(named: "bill_line2"))
        line2Image.frame = CGRectMake(0, ((screen.size.height * 46) / 736) + subView_y + (lineView_y * count), (screen.size.width * 392) / 414, (screen.size.height * 5) / 736)
        contentView.addSubview(line2Image)
        
        let gratitudeView = UIView()
        gratitudeView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count) + ((screen.size.height * 51) / 736), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        gratitudeView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(gratitudeView)
        
        let gratitudeTitle = UILabel()
        gratitudeTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        gratitudeTitle.text = "Gratitude"
        gratitudeTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        gratitudeTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        gratitudeView.addSubview(gratitudeTitle)
        
        gratitudeValue = UILabel()
        gratitudeValue.frame = CGRectMake((screen.size.width * 211) / 414, (screen.size.height * 13) / 736, (screen.size.width * 60) / 414, (screen.size.height * 20) / 736)
        gratitudeValue.text = (historyDetailData.objectForKey("gratitudeRatio") as! Int).description + "%"
        gratitudeValue.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        gratitudeValue.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        gratitudeValue.textAlignment = .Right
        gratitudeView.addSubview(gratitudeValue)
        
        gratitudeAmount = UILabel()
        gratitudeAmount.frame = CGRectMake((screen.size.width * 301) / 414, (screen.size.height * 13) / 736, (screen.size.width * 80) / 414, (screen.size.height * 20) / 736)
        //        let amount = (subTotal * (Double(10) / 100))
        gratitudeAmount.text = (historyDetailData.objectForKey("gratitude") as! Double).format(someDoubleFormat) + "KD"
        gratitudeAmount.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        gratitudeAmount.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        gratitudeAmount.textAlignment = .Right
        gratitudeView.addSubview(gratitudeAmount)
        
        let totalView = UIView()
        totalView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count) + ((screen.size.height * 97) / 736), (screen.size.width * 392) / 414, (screen.size.height * 58) / 736)
        totalView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(totalView)
        
        let totalTitle = UILabel()
        totalTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 19) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        totalTitle.text = "TOTAL"
        totalTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        totalView.addSubview(totalTitle)
        
        totalPrice = UILabel()
        totalPrice.frame = CGRectMake((screen.size.width * 261) / 414, (screen.size.height * 19) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        totalPrice.text = (historyDetailData.objectForKey("total") as! Double).format(someDoubleFormat) + "KD"
        totalPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalPrice.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        totalPrice.textAlignment = .Right
        totalView.addSubview(totalPrice)
        
        //크기 가변으로 해야 스크롤뷰로 볼수 있다
        contentView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 19) / 736 + 20, (screen.size.width * 392) / 414, (totalView.frame.origin.y + totalView.frame.height))
        
        let contentView_y =  (contentView.frame.origin.y + contentView.frame.height)
        
        
        let bottomImage = UIImageView(image: UIImage(named: "bill_bottom"))
        bottomImage.frame = CGRectMake((screen.size.width * 11) / 414, contentView_y, (screen.size.width * 392) / 414, (screen.size.height * 19) / 736)
        popUpScrollView.addSubview(bottomImage)
        
        self.view.addSubview(self.popUp)
        
        window.addSubview(self.view)
        
        let popUpHeight = bottomImage.frame.origin.y + bottomImage.frame.size.height
        popUpScrollView.contentSize = CGSize(width: screen.size.width, height: popUpHeight)
        
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

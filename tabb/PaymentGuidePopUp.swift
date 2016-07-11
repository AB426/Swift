//
//  PaymentGuidePopUp.swift
//  tabb
//
//  Created by LeeDongMin on 1/5/16.
//  Copyright © 2016 LeeDongMin. All rights reserved.
//

import UIKit

class PaymentGuidePopUp: UIViewController {
    
    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
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

        let close = UIButton()
        close.frame = CGRectMake((screen.size.width * 370) / 414, (screen.size.height * 30) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        close.setBackgroundImage(UIImage(named: "btn_x3"), forState: .Normal)
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(close)
        
        let peopleGuideView = UIView()
        peopleGuideView.frame = CGRectMake((screen.size.width * 22) / 414, (screen.size.height * 92) / 736, (screen.size.width * 370) / 414, (screen.size.height * 77) / 736)
        peopleGuideView.addDashedBorder(UIColor.whiteColor().CGColor, radius: peopleGuideView.frame.size.width / 2)
        self.popUp.addSubview(peopleGuideView)
        
        let billTransferGuideTitle = UILabel()
        billTransferGuideTitle.frame = CGRectMake((screen.size.width * 30) / 414, (screen.size.height * 7) / 736, (screen.size.width * 332) / 414, (screen.size.height * 20) / 736)
        billTransferGuideTitle.text = "Bill Transfer"
        billTransferGuideTitle.font = UIFont(name: latoBold, size: (screen.size.width * 17) / 414)
        billTransferGuideTitle.textColor = UIColor.whiteColor()
        billTransferGuideTitle.textAlignment = .Center
        peopleGuideView.addSubview(billTransferGuideTitle)
        
        let billTransferGuideScript = UILabel()
        billTransferGuideScript.frame = CGRectMake((screen.size.width * 20) / 414, (screen.size.height * 28) / 736, (screen.size.width * 352) / 414, (screen.size.height * 42) / 736)
        billTransferGuideScript.numberOfLines = 0
        billTransferGuideScript.text = "If you wish to pay for someone or vice versa.\nTab icon of the person from the top."
        billTransferGuideScript.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        billTransferGuideScript.textColor = UIColor.whiteColor()
        billTransferGuideScript.textAlignment = .Center
        peopleGuideView.addSubview(billTransferGuideScript)

        let itemGuideView = UIView()
        itemGuideView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 202) / 736, (screen.size.width * 392) / 414, (screen.size.height * 77) / 736)
        itemGuideView.addDashedBorder(UIColor.whiteColor().CGColor, radius: (screen.size.width * 5) / 414)
        self.popUp.addSubview(itemGuideView)
        
        let splitGuideTitle = UILabel()
        splitGuideTitle.frame = CGRectMake((screen.size.width * 30) / 414, (screen.size.height * 7) / 736, (screen.size.width * 332) / 414, (screen.size.height * 20) / 736)
        splitGuideTitle.text = "Split Your Bill"
        splitGuideTitle.font = UIFont(name: latoBold, size: (screen.size.width * 17) / 414)
        splitGuideTitle.textColor = UIColor.whiteColor()
        splitGuideTitle.textAlignment = .Center
        itemGuideView.addSubview(splitGuideTitle)
        
        let splitGuideScript = UILabel()
        splitGuideScript.frame = CGRectMake((screen.size.width * 20) / 414, (screen.size.height * 28) / 736, (screen.size.width * 352) / 414, (screen.size.height * 42) / 736)
        splitGuideScript.numberOfLines = 0
        splitGuideScript.text = "Tab the food icon to allow split pop-up page.\nSelect whom you wish to split your bill with."
        splitGuideScript.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        splitGuideScript.textColor = UIColor.whiteColor()
        splitGuideScript.textAlignment = .Center
        itemGuideView.addSubview(splitGuideScript)
        
        let bottomView = UIView()
        bottomView.frame = CGRectMake((screen.size.width * 77) / 414, (screen.size.height * 520) / 736, (screen.size.width * 260) / 414, (screen.size.height * 40) / 736)
        self.popUp.addSubview(bottomView)
        
        let notAgain = UIButton()
        notAgain.frame = CGRectMake(0, (screen.size.height * 6.5) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        notAgain.setBackgroundImage(UIImage(named: "btn_check"), forState: .Normal)
        notAgain.addTarget(self, action: "guideViewGone:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(notAgain)
        
        let againTitle = UILabel()
        againTitle.frame = CGRectMake((screen.size.width * 35) / 414, (screen.size.height * 10) / 736, (screen.size.width * 220) / 414, (screen.size.height * 20) / 736)
        againTitle.text = "I don't want to read this message again."
        againTitle.font = UIFont(name: lato, size: (screen.size.width * 12) / 414)
        againTitle.textColor = UIColor.whiteColor()
        bottomView.addSubview(againTitle)
        
        //self.updateDisplay()
        
        
        self.view.addSubview(self.popUp)
        
        window.addSubview(self.view)
        
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
    
    func updateDisplay() {
        
        let subViews = self.popUp.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    }
    
    func close(sender: AnyObject?) {
        self.removeAnimate()
    }
    
    func guideViewGone(sender: AnyObject?) {
        self.removeAnimate()
        pref.setBool(true, forKey: "guideCheck")
    }
}

//
//  PopUpViewController.swift
//  twothumbs
//
//  Created by LeeDongMin on 2015. 8. 5..
//  Copyright (c) 2015년 LeeDongMin. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation

class PopUpViewController : UIViewController, UITextFieldDelegate {

    var message = UILabel()
    var popUp = UIView()
    var inputPass = MyTextField()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            self.view.backgroundColor = UIColorFromHex(0x111111, alpha: 0.8)
            
            //popUp.frame = CGRectMake((screen.size.width * 50) / 414, (screen.size.height * 253) / 736, (screen.size.width * 315) / 414, (screen.size.height * 230) / 736)
            
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
            self.view.addGestureRecognizer(tap)
        })
        
        
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //self.view.addSubview(popUp)
    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool) {
        //popUp.removeFromSuperview()
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            
            let window = UIApplication.sharedApplication().keyWindow!
            let menuWrapperBounds = window.bounds
            
            self.popUp = UIView()
            let screen: CGRect = UIScreen.mainScreen().bounds
            self.popUp.layer.shadowOpacity = 0.8
            self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
            self.popUp.backgroundColor = UIColor.clearColor()
            self.popUp.frame = CGRectMake(0, 0,  menuWrapperBounds.width, menuWrapperBounds.height)
            
            
            let topImage = UIImageView(image: UIImage(named: "pop_top"))
            topImage.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 211) / 736, (screen.size.width * 320) / 414, (screen.size.height * 124) / 736)
            self.popUp.addSubview(topImage)
            
            let contentView = UIView()
            contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 335) / 736, (screen.size.width * 320) / 414, (screen.size.height * 110) / 736)
            contentView.backgroundColor = UIColor.whiteColor()
            self.popUp.addSubview(contentView)
            
            let cartImage = UIImageView(image: UIImage(named: "icon_pop1"))
            cartImage.frame = CGRectMake((screen.size.width * 142.5) / 414, 0, (screen.size.width * 35) / 414, (screen.size.height * 35) / 736)
            contentView.addSubview(cartImage)
            let cartTitle = UILabel()
            cartTitle.frame = CGRectMake((screen.size.width * 70) / 414, (screen.size.height * 35) / 736, (screen.size.width * 180) / 414, (screen.size.height * 30) / 736)
            cartTitle.text = "Added to cart!"
            cartTitle.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
            cartTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
            cartTitle.textAlignment = .Center
            contentView.addSubview(cartTitle)
//            let cartScript = UILabel()
//            cartScript.frame = CGRectMake((screen.size.width * 20) / 414, (screen.size.height * 65) / 736, (screen.size.width * 280) / 414, (screen.size.height * 80) / 736)
//            cartScript.numberOfLines = 0
//            cartScript.text = "장바구니 메뉴에서 선택하신 모든 메뉴와\n옵션 사항을 모두 확인하실 수 있습니다.\n계속해서 메뉴를 둘러 보거나\n카트 메뉴로 가서 내용을 확인하세요."
//            cartScript.textColor = UIColorFromHex(0x666666, alpha: 1.0)
//            cartScript.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
//            cartScript.textAlignment = .Center
//            contentView.addSubview(cartScript)
            
            let confirmView = UIView()
            let closeView = UIView()
            
            let confirm: UIButton = UIButton()
            let close: UIButton = UIButton()
            
            closeView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 445) / 736, (screen.size.width * 160) / 414, (screen.size.height * 80) / 736)
            closeView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
            closeView.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
            self.popUp.addSubview(closeView)
            
            let closeTitle = UILabel()
            closeTitle.frame = CGRectMake(0, (screen.size.height * 10) / 736, (screen.size.width * 160) / 414, (screen.size.height * 60) / 736)
            closeTitle.text = "KEEP\nBROWSING"
            closeTitle.textColor = UIColor.whiteColor()
            closeTitle.backgroundColor = UIColor.clearColor()
            closeTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
            closeTitle.textAlignment = .Center
            closeTitle.numberOfLines = 0
            closeView.addSubview(closeTitle)
            
            close.frame = CGRectMake(0, 0, (screen.size.width * 160) / 414, (screen.size.height * 80) / 736)
            close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0)), forState: .Normal)
            close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
            close.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
            close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
            closeView.addSubview(close)
            
            confirmView.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 445) / 736, (screen.size.width * 160) / 414, (screen.size.height * 80) / 736)
            confirmView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
            confirmView.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
            self.popUp.addSubview(confirmView)
            
            let confirmTitle = UILabel()
            confirmTitle.frame = CGRectMake(0, (screen.size.height * 10) / 736, (screen.size.width * 160) / 414, (screen.size.height * 60) / 736)
            confirmTitle.text = "GO TO\nCART"
            confirmTitle.textColor = UIColor.whiteColor()
            confirmTitle.backgroundColor = UIColor.clearColor()
            confirmTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
            confirmTitle.textAlignment = .Center
            confirmTitle.numberOfLines = 0
            confirmView.addSubview(confirmTitle)
            
            confirm.frame = CGRectMake(0, 0, (screen.size.width * 160) / 414, (screen.size.height * 80) / 736)
            confirm.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0)), forState: .Normal)
            confirm.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
            confirm.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
            confirm.addTarget(self, action: "confirm:", forControlEvents: UIControlEvents.TouchUpInside)
            confirmView.addSubview(confirm)
            
            let line = UIView()
            line.frame = CGRectMake((screen.size.width * 206) / 414, (screen.size.height * 445) / 736, 1, (screen.size.height * 80) / 736)
            line.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
            self.popUp.addSubview(line)
            
            self.view.addSubview(self.popUp)
            
            window.addSubview(self.view)
            

        })
        
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
        if(dishViewBackFlag == true) {
            dishViewBackFlag = false
            dishView.backToBrowseMenu()
        }
        self.removeAnimate()
    }
    
    func confirm(sender: AnyObject?) {
        self.removeAnimate()
     
        let window = UIApplication.sharedApplication().windows[0]
        let tab : UITabBarController = window.rootViewController as! UITabBarController
        tab.selectedIndex = 1
    }
    
    class MyTextField : UITextField {
        var leftTextMargin : CGFloat = 0.0
        
        override func textRectForBounds(bounds: CGRect) -> CGRect {
            var newBounds = bounds
            newBounds.origin.x += leftTextMargin
            return newBounds
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect {
            var newBounds = bounds
            newBounds.origin.x += leftTextMargin
            return newBounds
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 160
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 160
    }
    
        
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

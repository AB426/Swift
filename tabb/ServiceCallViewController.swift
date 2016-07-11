//
//  ServiceCallViewController.swift
//  tabb
//
//  Created by LeeDongMin on 12/30/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class ServiceCallViewController: UIViewController, UITextFieldDelegate {

    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
    var foodStuffView : UIView!
    var nonFoodStuffView : UIView!
    var foodTitle : UILabel!
    var nonFoodTitle : UILabel!
    
    var foodCallList : NSArray!
    var nonFoodCallList : NSArray!
    
    var callTypeCheck = false
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var customCall : UITextField!
    
    var contentHeight : CGFloat!
    
    //서비스콜 이미지 로딩
    var NONE = "icon_service0"

    var FORK = "icon_service1_1"
    var KNIFE = "icon_service1_2"
    var SPOON = "icon_service1_3"
    var TEA_SPOON = "icon_service1_4"
    var BOWL = "icon_service1_5"
    var PLATE = "icon_service1_6"
    var NAPKINS = "icon_service1_7"
    var TABLE_CLEAN = "icon_service1_8"
    var SERVER = "icon_service1_9"
    var CUP = "icon_service1_10"
    
    var SALT =  "icon_service2_1"
    var BLACK_PEPPER = "icon_service2_2"
    var SUGAR = "icon_service2_3"
    var SOY_SAUCE = "icon_service2_4"
    var OLIVE_OIL = "icon_service2_5"
    var TOMATO_KETCHUP = "icon_service2_7"
    var MUSTARD = "icon_service2_8"
    var HOT_SAUCE = "icon_service2_6"
    var MAYONNAISE = "icon_service2_9"
    var SYRUP = "icon_service2_10"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
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

        let callTitle = UILabel()
        callTitle.frame = CGRectMake((screen.size.width * 15) / 414, (screen.size.height * 38) / 736, (screen.size.width * 350) / 414, (screen.size.height * 20) / 736)
        callTitle.text = "Click the service item. We'll serve you shortly."
        callTitle.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        callTitle.backgroundColor = UIColor.clearColor()
        callTitle.font = UIFont(name: lato, size: (screen.size.width * 15 / 414))
        self.popUp.addSubview(callTitle)
        
        let close = UIButton()
        close.frame = CGRectMake((screen.size.width * 366) / 414, (screen.size.height * 31) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        close.setBackgroundImage(UIImage(named: "btn_x3"), forState: .Normal)
        close.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        self.popUp.addSubview(close)

        foodStuffView = UIView()
        foodStuffView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 81) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        foodStuffView.backgroundColor = UIColorFromHex(0xfe7c7c, alpha: 1.0)
        self.popUp.addSubview(foodStuffView)
        
        foodTitle = UILabel()
        foodTitle.text = "FOOD STUFF"
        foodTitle.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        foodTitle.textAlignment = .Center
        foodTitle.backgroundColor = UIColor.clearColor()
        foodTitle.font = UIFont(name: robotoBold, size: (screen.size.width * 15 / 414))
        foodTitle.frame = CGRectMake(0, (screen.size.height * 15) / 736, (screen.size.width * 192) / 414, (screen.size.height * 24) / 736)
        foodStuffView.addSubview(foodTitle)
        
        let foodBtn = UIButton()
        foodBtn.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 81) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        foodBtn.tag = 1
        foodBtn.addTarget(self, action: "changeView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(foodBtn)
        
        nonFoodStuffView = UIView()
        nonFoodStuffView.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 81) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        nonFoodStuffView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
        self.popUp.addSubview(nonFoodStuffView)
        
        nonFoodTitle = UILabel()
        nonFoodTitle.text = "NON FOOD STUFF"
        nonFoodTitle.textColor = UIColorFromHex(0x333333, alpha: 1.0)
        nonFoodTitle.textAlignment = .Center
        nonFoodTitle.backgroundColor = UIColor.clearColor()
        nonFoodTitle.font = UIFont(name: robotoBold, size: (screen.size.width * 15 / 414))
        nonFoodTitle.frame = CGRectMake(0, (screen.size.height * 15) / 736, (screen.size.width * 192) / 414, (screen.size.height * 24) / 736)
        nonFoodStuffView.addSubview(nonFoodTitle)
        
        let nonFoodBtn = UIButton()
        nonFoodBtn.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 81) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        nonFoodBtn.tag = 2
        nonFoodBtn.addTarget(self, action: "changeView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(nonFoodBtn)
        
        viewBox(nonFoodStuffView, value: 0xcccccc, border: 1, radius: 0)
        viewBox(nonFoodStuffView, value: 0xcccccc, border: 1, radius: 0)
        
        //서비스콜 목록.
        
        popUpScrollView = UIScrollView()
        popUpScrollView.backgroundColor = UIColor.clearColor()
        popUpScrollView.frame = CGRectMake(0, (screen.size.height * 135) / 736, menuWrapperBounds.width, (screen.size.height * 601) / 736)
        self.popUp.addSubview(popUpScrollView)
        
        foodCallList = serviceCallList.objectForKey("FOOD") as! NSArray
        nonFoodCallList = serviceCallList.objectForKey("NON_FOOD") as! NSArray
        
        self.updateDisplay()

        
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
        
        let subViews = popUpScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        let viewWidht = (screen.size.width * 96) / 414
        let viewHeight = (screen.size.height * 110) / 736
        let leftMargin = (screen.size.width * 38) / 414
        let topMargin = (screen.size.height * 20) / 736
        var leftCount : CGFloat = 0
        var topCount : CGFloat = 0
        var serviceCallCount = 0
        
        if(!callTypeCheck) {
            for(var index = 0; index < foodCallList.count; ++index) {
                let callView = UIView()
                callView.frame = CGRectMake((screen.size.width * 25) / 414  + (leftMargin * leftCount) + (viewWidht * leftCount), (screen.size.height * 23) / 736 + (topMargin * topCount)  + (viewHeight * topCount), viewWidht, viewHeight)
                popUpScrollView.addSubview(callView)
                
                let callBackView = UIView()
                callBackView.frame = CGRectMake(0, 0, (screen.size.width * 96) / 414, (screen.size.height * 96) / 736)
                callBackView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.5)
                callBackView.layer.cornerRadius = callBackView.frame.size.width / 2
                callView.addSubview(callBackView)
                
                let callBtn = UIButton()
                callBtn.frame = CGRectMake((screen.size.width * 9.5) / 414, (screen.size.height * 9.5) / 736, (screen.size.width * 77) / 414, (screen.size.height * 77) / 736)
                let iconName = foodCallList[index].objectForKey("icon") as! String
                callBtn.setBackgroundImage(UIImage(named: iconName), forState: .Normal)
                callBtn.tag = index
                callBtn.addTarget(self, action: "sendImageServiceCall:", forControlEvents: .TouchUpInside)
                callView.addSubview(callBtn)
                
                let callTitle = UILabel()
                callTitle.frame = CGRectMake(0, (screen.size.height * 96) / 736, (screen.size.width * 96) / 414, (screen.size.height * 14) / 736)
                callTitle.text = foodCallList[index].objectForKey("name") as? String
                callTitle.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                callTitle.textAlignment = .Center
                callTitle.adjustsFontSizeToFitWidth = true
                callTitle.font = UIFont(name: latoBold, size: (screen.size.width * 12) / 414)
                callView.addSubview(callTitle)
                
                ++leftCount
                
                if(leftCount % 3 == 0) {
                    leftCount = 0
                    
                    ++topCount
                }
                
                ++serviceCallCount
                
            }
        } else {
            for(var index = 0; index < nonFoodCallList.count; ++index) {
                let callView = UIView()
                callView.frame = CGRectMake((screen.size.width * 25) / 414  + (leftMargin * leftCount) + (viewWidht * leftCount), (screen.size.height * 23) / 736 + (topMargin * topCount)  + (viewHeight * topCount), viewWidht, viewHeight)
                popUpScrollView.addSubview(callView)
                
                let callBackView = UIView()
                callBackView.frame = CGRectMake(0, 0, (screen.size.width * 96) / 414, (screen.size.height * 96) / 736)
                callBackView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.5)
                callBackView.layer.cornerRadius = callBackView.frame.size.width / 2
                callView.addSubview(callBackView)
                
                let callBtn = UIButton()
                callBtn.frame = CGRectMake((screen.size.width * 9.5) / 414, (screen.size.height * 9.5) / 736, (screen.size.width * 77) / 414, (screen.size.height * 77) / 736)
                callBtn.setBackgroundImage(UIImage(named: (nonFoodCallList[index].objectForKey("icon") as? String)!), forState: .Normal)
                callBtn.tag = index
                callBtn.addTarget(self, action: "sendImageServiceCall:", forControlEvents: .TouchUpInside)
                callView.addSubview(callBtn)
                
                let callTitle = UILabel()
                callTitle.frame = CGRectMake(0, (screen.size.height * 96) / 736, (screen.size.width * 96) / 414, (screen.size.height * 14) / 736)
                callTitle.text = nonFoodCallList[index].objectForKey("name") as? String
                callTitle.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
                callTitle.textAlignment = .Center
                callTitle.adjustsFontSizeToFitWidth = true
                callTitle.font = UIFont(name: latoBold, size: (screen.size.width * 12) / 414)
                callView.addSubview(callTitle)
                
                ++leftCount
                
                if(leftCount % 3 == 0) {
                    leftCount = 0
                    ++topCount
                }
                
                ++serviceCallCount
            }
        }
        
        //서비스콜 갯수가 3의 배수가 되면, 즉 3, 6, 9....가 되면 서비스콜 배치때문에 하단의 입력되는 텍스트 필드가 한줄 뜨게 된다.
        //그러므로, 3의 배수일 경우네는 topCount를 1 줄여서 서비스콜 배치때문에 생기는 텍스트 필드의 밀림 현상을 제거하여 준다.
        if(serviceCallCount % 3 == 0) {
            --topCount
        }
        
        let bottomView = UIView()
        bottomView.frame = CGRectMake((screen.size.width * 27) / 414, (screen.size.height * 23) / 736 + (topMargin * topCount)  + (viewHeight * (topCount + 1)) + (screen.size.height * 38) / 736, (screen.size.width * 360) / 414, (screen.size.height * 48) / 736)
        bottomView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.5)
        bottomView.layer.borderWidth = 0.5
        bottomView.layer.borderColor = UIColorFromHex(0xffffff, alpha: 0.5).CGColor
        bottomView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        popUpScrollView.addSubview(bottomView)
        
        customCall = UITextField()
        customCall.frame = CGRectMake((screen.size.width * 17) / 414, (screen.size.height * 9) / 736, (screen.size.width * 250) / 414, (screen.size.height * 30) / 736)
        customCall.text = "Not in the list? Type in what you need"
        customCall.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        customCall.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        customCall.delegate = self
        bottomView.addSubview(customCall)
        
        let customBtn = UIButton()
        customBtn.frame = CGRectMake((screen.size.width * 316) / 414, (screen.size.height * 10.5) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        customBtn.setBackgroundImage(UIImage(named: "icon_service00"), forState: .Normal)
        customBtn.addTarget(self, action: "sendCustomServiceCall:", forControlEvents: .TouchUpInside)
        bottomView.addSubview(customBtn)
        
        contentHeight = bottomView.frame.origin.y + bottomView.frame.size.height + (screen.size.height * 48) / 736
        
        popUpScrollView.contentSize = CGSize(width: screen.size.width, height: contentHeight)
        
        
    }
    
    func changeView(sender : AnyObject?) {
        if(sender!.tag == 1) {

            foodStuffView.backgroundColor = UIColorFromHex(0xfe7c7c, alpha: 1.0)
            nonFoodStuffView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
            foodTitle.textColor = UIColor.whiteColor()
            nonFoodTitle.textColor = UIColorFromHex(0x333333, alpha: 1.0)
            callTypeCheck = false
            self.updateDisplay()
            
        } else {
            foodStuffView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
            nonFoodStuffView.backgroundColor = UIColorFromHex(0xfe7c7c, alpha: 1.0)
            foodTitle.textColor = UIColorFromHex(0x333333, alpha: 1.0)
            nonFoodTitle.textColor = UIColor.whiteColor()
            callTypeCheck = true
            self.updateDisplay()

        }
    }
    
    func sendImageServiceCall(sender : AnyObject?) {
        if(!callTypeCheck) {
            print(foodCallList[sender!.tag].objectForKey("name") as! String)
            sendServiceCall(nonFoodCallList[sender!.tag].objectForKey("name") as! String)
        } else {
            print(nonFoodCallList[sender!.tag].objectForKey("name") as! String)
            sendServiceCall(nonFoodCallList[sender!.tag].objectForKey("name") as! String)
        }
        
    }
    
    func sendCustomServiceCall(sender : AnyObject?) {
        if(customCall.text == "") {
            return;
        }
        sendServiceCall(customCall.text!)
    }
    
    func close(sender: AnyObject?) {
        self.removeAnimate()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(customCall.text == "") {
            customCall.text = "Not in the list? Type in what you need"
            customCall.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        customCall.text = ""
        customCall.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if(showCheck == true) {
            return;
        }
        
        showCheck = true
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {

            //self.view.frame.origin.y -= 160
            
            self.popUpScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            self.popUpScrollView.contentOffset.y += keyboardSize.size.height
            
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        //self.view.frame.origin.y += 160
        
        if(showCheck == false) {
            return;
        }
        
        if(customCall.text == "") {
            customCall.text = "Not in the list? Type in what you need"
            customCall.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        }
        
        showCheck = false
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //self.view.frame.origin.y += 160
            //self.popUpScrollView.contentOffset.y -= keyboardSize.size.height
            //self.popUpScrollView.contentInset = UIEdgeInsetsMake(0, 0, -keyboardSize.height, 0)
            self.popUpScrollView.contentSize = CGSize(width: screen.size.width, height: contentHeight)
        }
        
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func sendServiceCall(serviceCallName : String) {
        let url: String = serverURL + "user/serviceCall/request"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId, "serviceCallName": serviceCallName]
        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            dispatch_async(dispatch_get_main_queue(), {
                                let windowView = UIApplication.sharedApplication().keyWindow!
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: "Your call acknowledged.\nYou will be served shortly", animated: true)
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                let windowView = UIApplication.sharedApplication().keyWindow!
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: "Failed send service call", animated: true)
                            })
                        }
                        
                        
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }

}

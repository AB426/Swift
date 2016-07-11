//
//  CustomPopUp.swift
//  tabb
//
//  Created by LeeDongMin on 12/10/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class CustomPopUp: UIViewController {

    var message = UILabel()
    var popUp = UIView()
    
    var loginView : LoginViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x111111, alpha: 0.8)
        
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
        
        
        let topImage = UIImageView(image: UIImage(named: "pop_top"))
        topImage.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 150) / 736, (screen.size.width * 320) / 414, (screen.size.height * 124) / 736)
        self.popUp.addSubview(topImage)
        
        let contentView = UIView()
        contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 274) / 736, (screen.size.width * 320) / 414, (screen.size.height * 150) / 736)
        contentView.backgroundColor = UIColor.whiteColor()
        self.popUp.addSubview(contentView)
        
       
        let popMessage = UILabel()
        popMessage.frame = CGRectMake((screen.size.width * 30) / 414, (screen.size.height * 25) / 736, (screen.size.width * 260) / 414, (screen.size.height * 100) / 736)
        popMessage.text = message
        popMessage.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        popMessage.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        popMessage.textAlignment = .Center
        popMessage.numberOfLines = 0
        contentView.addSubview(popMessage)

        let close: UIButton = UIButton()
        
        close.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 424) / 736, (screen.size.width * 320) / 414, (screen.size.height * 54) / 736)
        close.setTitle("OK", forState: UIControlState.Normal)
        close.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        close.roundCorners(([.BottomLeft, .BottomRight]), radius: (screen.size.width * 3.5) / 414)
        close.clipsToBounds = true
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(close)

        self.view.addSubview(self.popUp)
        
        window.addSubview(self.view)
        
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
        
        if(paymentChk == true) {
            paymentChk = false
            paymentDetail.backPressed(sender)
            let window = UIApplication.sharedApplication().windows[0]
            let tab : UITabBarController = window.rootViewController as! UITabBarController
            tab.selectedIndex = 3
        }
        
        if(makeOrderFlag) {
            makeOrderFlag = false
            myCart.goPayment()
        }
        
        if(profileChangeCheck) {
            profileModify.backPressed(nil)
        }
        
        if(notCheck) {
            checkinId = 0
            restaurantId = 0
            cartId = 0
            checkinChk = false
            searchCheck = false
            likeChk = false
        }
        
//        if(signOutFlag) {
//            signOutFlag = false
//            self.signOut()
//        }
    }

    
    func signOut() {
        //로그아웃이 되면서 체크아웃이 되면,
        //chekcinId, restaurantId, cartId 등을 앱 내부에 저장된 데이터에서 지워줘야 한다.
        
        let url: String = serverURL + "user/auth/logout"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey]
        
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
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        print(post)
                        let status = post["status"] as! Int
                        
                        if status == 0 {
                            
                            var deviceToken : String!
                            
                            if(pref.objectForKey("deviceToken") as? String == nil) {
                                deviceToken = ""
                            } else {
                                deviceToken = pref.objectForKey("deviceToken") as! String
                            }
                            
                            let identifier =  pref.objectForKey("identifier") as! String
                            
                            for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
                                NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
                            }
                            
                            pref.setObject(deviceToken, forKey: "deviceToken")
                            pref.setObject(identifier, forKey: "identifier")
                            
                            print(pref.objectForKey("deviceToken") as! String)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginNavi = storyboard.instantiateViewControllerWithIdentifier("loginNavi") as! UINavigationController
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                loginNavi.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                                let window = UIApplication.sharedApplication().windows[0]
                                UIView.transitionFromView(window.rootViewController!.view,toView: loginNavi.view,
                                    duration: 0.65,options: .TransitionCrossDissolve,
                                    completion: {finished in window.rootViewController = loginNavi})
                            })
                            
                            
                        } else if(status == HAVE_PAY_BILL){
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        } else if(status == HAVE_ORDER_FOOD){
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
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

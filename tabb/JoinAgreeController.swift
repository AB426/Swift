//
//  JoinAgreeController.swift
//  tabb
//
//  Created by LeeDongMin on 12/10/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class JoinAgreeController: UIViewController, CheckboxDelegate, UITextFieldDelegate {

    @IBOutlet weak var joinAgreeBack: UIView!
    
    var phoneNum : UITextField!
    
    var agreeChk : Bool = false
    
    private var tabBar: TabBarController!
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var deviceToken : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBar") as! TabBarController

        phoneNum = UITextField()
        phoneNum.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 107) / 736, (screen.size.width * 392) / 414, (screen.size.height * 30) / 736)
        phoneNum.backgroundColor = UIColor.clearColor()
        phoneNum.textAlignment = .Center
        phoneNum.textColor = UIColor.whiteColor()
        phoneNum.keyboardType = UIKeyboardType.NumberPad
        phoneNum.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        phoneNum.attributedPlaceholder = NSAttributedString(string:"Enter your Phone number",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        joinAgreeBack.addSubview(phoneNum)
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.BlackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "apply")
        ]
        
        numberToolbar.sizeToFit()
        
        phoneNum.inputAccessoryView = numberToolbar
        
        let agreeLine1 = UIView()
        agreeLine1.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 147) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        agreeLine1.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        joinAgreeBack.addSubview(agreeLine1)
        
        let agreeImage = UIImageView(image: UIImage(named: "icon_history"))
        agreeImage.frame = CGRectMake((screen.size.width * 26) / 414, (screen.size.height * 225) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        let serviceTitle = UILabel()
        serviceTitle.frame = CGRectMake((screen.size.width * 70) / 414, (screen.size.height * 225) / 736, (screen.size.width * 392) / 414, (screen.size.height * 27) / 736)
        serviceTitle.text = "Term of service"
        serviceTitle.textColor = UIColor.whiteColor()
        serviceTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        serviceTitle.textAlignment = .Left
        
        joinAgreeBack.addSubview(agreeImage)
        joinAgreeBack.addSubview(serviceTitle)
        
        let agreeLine2 = UIView()
        agreeLine2.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 265) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        agreeLine2.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        joinAgreeBack.addSubview(agreeLine2)
        
        let lFrame = CGRectMake((screen.size.width * 23) / 414, (screen.size.height * 275) / 736, (screen.size.width * 392) / 414, (screen.size.height * 40) / 736)
        let lCheckbox = Checkbox(frame: lFrame, selected: false, checkValue: 1)
        lCheckbox.mDelegate = self
        let agreeTitle = UILabel()
        agreeTitle.frame = CGRectMake((screen.size.width * 70) / 414, (screen.size.height * 275) / 736, (screen.size.width * 320) / 414, (screen.size.height * 40) / 736)
        agreeTitle.text = "I agree to the general terms and\nprivacy policy of this service."
        agreeTitle.textColor = UIColor.whiteColor()
        agreeTitle.numberOfLines = 0
        agreeTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        agreeTitle.textAlignment = .Left
        
        joinAgreeBack.addSubview(lCheckbox)
        joinAgreeBack.addSubview(agreeTitle)
        
        let nextView = UIView()
        nextView.frame = CGRect(x: (screen.size.width * 170 / 414), y: (screen.size.height * 520 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        nextView.layer.cornerRadius = nextView.frame.size.width / 2
        joinAgreeBack.addSubview(nextView)
        
        let nextImage = UIImageView(image: UIImage(named: "btn_next"))
        nextImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
        nextView.addSubview(nextImage)
        
        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextBtn.backgroundColor = UIColor.clearColor()
        nextBtn.layer.cornerRadius = nextBtn.frame.size.width / 2
        nextBtn.addTarget(self, action: "tabbJoin:", forControlEvents: .TouchUpInside)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
        nextBtn.clipsToBounds = true
        nextView.addSubview(nextBtn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func cancel () {
        self.phoneNum.resignFirstResponder()
    }
    
    func apply() {
        self.phoneNum.resignFirstResponder()
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if(showCheck == true) {
            return;
        }
        
        showCheck = true
        
        self.view.frame.origin.y -= 160
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        self.view.frame.origin.y += 160
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func didSelectCheckbox(state: Bool, identifier: Int) {
        print("checkbox '\(identifier)' has state \(state)");
        
        agreeChk = state
        
    }
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(userId: Int, data:NSData, boundary:String, fileName:String) -> NSData {
        let fullData = NSMutableData()
        
        // 0 - Boundary should start with --
        let lineZero = "--" + boundary + "\r\n"
        fullData.appendData(lineZero.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        fullData.appendData(("Content-Disposition: form-data; name=\"userId\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        fullData.appendData(("\(userId)\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.appendData(lineOne.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.appendData(lineTwo.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.appendData(lineThree.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 4
        fullData.appendData(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.appendData(lineFive.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.appendData(lineSix.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        return fullData
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    func tabbJoin(sender: AnyObject?) {
        
        self.phoneNum.resignFirstResponder()
        
        if(phoneNum.text == "") {
            customPop.showInView(self.view, withMessage: "Please enter your phone number.", animated: true)
            return;
        }
        
        if(agreeChk == false) {
            customPop.showInView(self.view, withMessage: "Please agree to the Terms and Conditions.", animated: true)
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            showActivityIndicator(windowView)
        })

        let url: String = serverURL + "guest/user/regUser"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let email = pref.objectForKey("email") as! String
        let password = pref.objectForKey("password") as! String
        let userName = pref.objectForKey("userName") as! String
        let gender = pref.objectForKey("gender") as! String
        
        let newPost: NSDictionary = ["email": email, "password": password, "authType" : "EMAIL", "name" : userName, "sex" : gender, "birthDay" : birthDoubleValue, "phone" : phoneNum.text!]
        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        print("join newPost : \(newPost)")
        
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
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            
                            userId = post["data"]?.objectForKey("userId") as? Double
                            pref.setValue(userId, forKey: "userId")
                            pref.setValue(false, forKey: "snsCheck")
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                self.tabbJoinSendImage()
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: errorMsg, animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                })
                
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                
                return
            }
        }
        task.resume()
    }
    
    func tabbJoinSendImage() {

        let imageData: NSData = UIImageJPEGRepresentation(userProfileImage, 1)!
        let fileName = "profile.jpg"
        
        let url: String = serverURL + "guest/user/regUserImg"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let boundary = self.generateBoundaryString()
        let fullData = photoDataToFormData(Int.init(userId), data: imageData, boundary:boundary, fileName:fileName)
        
        
        request.HTTPBody = fullData
        request.HTTPShouldHandleCookies = false
        
        request.HTTPMethod = "POST"
        request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            pref.setValue(false, forKey: "snsCheck")
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                self.tabbLogin()
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                self.tabbLogin()
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tabbLogin()
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tabbLogin()
                    })
                    
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tabbLogin()
                })
                
                return
            }
        }
        task.resume()

    
    
    }
    
    
//    func tabbJoin(sender: AnyObject?) {
//
//        if(phoneNum.text == "") {
//            customPop.showInView(self.view, withMessage: "전화번호를 입력하셔야 가입을 할 수 있습니다.", animated: true)
//            return;
//        }
//
//        if(agreeChk == false) {
//            customPop.showInView(self.view, withMessage: "약관에 동의하셔야만 가입을 할 수 있습니다.", animated: true)
//            return;
//        }
//
//        dispatch_async(dispatch_get_main_queue(), {
//            // code here
//            let window = UIApplication.sharedApplication().keyWindow!
//            showActivityIndicator(window)
//        })
//
//        let imageData: NSData = UIImageJPEGRepresentation(userProfileImage, 1)!
//        let fileName = "profile1_1_1.jpg"
//
//        let url: String = serverURL + "guest/user/register"
//        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
//
//        let email = pref.objectForKey("email") as! String
//        let password = pref.objectForKey("password") as! String
//        let userName = pref.objectForKey("userName") as! String
//        let gender = pref.objectForKey("gender") as! String
//        
//        let newPost: NSDictionary = ["email": email, "password": password, "authType" : "EMAIL", "name" : userName, "sex" : gender, "birthDay" : birthDay, "phone" : phoneNum.text!]
//        
//        print("tabb join \(newPost)")
//        
//        var jsonString : String = ""
//        do {
//            // Try parsing some valid JSON
//            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
//            jsonString = NSString(data: postData, encoding: NSUTF8StringEncoding) as! String
//            print(jsonString)
//            
//        }
//        catch let error as NSError {
//            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
//            print("A JSON parsing error occurred, here are the details:\n \(error)")
//        }
//        
//        
//        let boundary = self.generateBoundaryString()
//        let fullData = photoDataToFormData(jsonString, data: imageData, boundary:boundary, fileName:fileName)
//        
//        
//        request.HTTPBody = fullData
//        request.HTTPShouldHandleCookies = false
//        
//        request.HTTPMethod = "POST"
//        request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if let httpResponse = response as? NSHTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    do {
//                        // Try parsing some valid JSON
//                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//                        print(post)
//                        let status = post["status"] as! Double
//                        
//                        if status == 0 {
//                            //성공
//                            
//                            userId = post["data"]?.objectForKey("userId") as? Double
//                            pref.setValue(userId, forKey: "userId")
//                            pref.setValue(false, forKey: "snsCheck")
//                            dispatch_async(dispatch_get_main_queue(), {
//                                // code here
//                                self.tabbLogin()
//                            })
//                        } else {
//                            let errorMsg: String! = post["error"] as! String
//                            print(errorMsg)
//                            
//                            dispatch_async(dispatch_get_main_queue(), {
//                                // code here
//                                
//                                let windowView = UIApplication.sharedApplication().keyWindow!
//                                hideActivityIndicator(windowView)
//                                
//                                customPop.showInView(self.view, withMessage: errorMsg, animated: true)
//                            })
//                        }
//                        
//                    }
//                    catch let error as NSError {
//                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
//                        print("A JSON parsing error occurred, here are the details:\n \(error)")
//                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            let windowView = UIApplication.sharedApplication().keyWindow!
//                            hideActivityIndicator(windowView)
//                        })
//                    }
//                    
//                } else {
//                    print("response was not 200: \(response)")
//                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        let windowView = UIApplication.sharedApplication().keyWindow!
//                        hideActivityIndicator(windowView)
//                    })
//                    
//                    return
//                }
//            }
//            if (error != nil) {
//                print("error submitting request: \(error)")
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    let windowView = UIApplication.sharedApplication().keyWindow!
//                    hideActivityIndicator(windowView)
//                })
//                
//                return
//            }
//        }
//        task.resume()
//    }
    
    func tabbLogin() {
        
        let url: String = serverURL + "guest/user/login"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let email = pref.objectForKey("email") as! String
        let password = pref.objectForKey("password") as! String
        
        if(pref.objectForKey("deviceToken") as? String == nil) {
            deviceToken = ""
        } else {
            deviceToken = pref.objectForKey("deviceToken") as! String
        }
        //deviceToken = pref.objectForKey("deviceToken") as! String
        let identifier: String = pref.objectForKey("identifier") as! String
        
        
        let newPost: NSDictionary = ["email": email, "password": password, "authType" : "EMAIL", "osType" : "IPHONE", "identifier" : identifier, "token" : deviceToken]
        
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
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공

                            pref.setDouble(post["data"]?.objectForKey("authId") as! Double, forKey: "authId")
                            pref.setValue(post["data"]?.objectForKey("authKey") as! String, forKey: "authKey")

                            pref.setBool(true, forKey: "loginCheck")
                            pref.setBool(false, forKey: "snsnLogin")
                            
                            pref.removeObjectForKey("password")
                            
                            checkinId = 0
                            pref.setValue(0, forKey: "checkinId")
                            if(pref.objectForKey("restaurantId") != nil) {
                                pref.removeObjectForKey("restaurantId")
                            }
                            if(pref.objectForKey("cartId") != nil) {
                                pref.removeObjectForKey("cartId")
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let windowView = UIApplication.sharedApplication().keyWindow!
                                hideActivityIndicator(windowView)
                                
                                for item in (self.tabBar.tabBar.items as NSArray!){
                                    (item as! UITabBarItem).image = (item as! UITabBarItem).image?.imageWithRenderingMode(.AlwaysOriginal)
                                    (item as! UITabBarItem).selectedImage = (item as! UITabBarItem).selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
                                }
                                
                                self.tabBar.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                                let window = UIApplication.sharedApplication().windows[0]
                                UIView.transitionFromView(window.rootViewController!.view,toView: self.tabBar.view,
                                    duration: 0.65,options: .TransitionCrossDissolve,
                                    completion: {finished in window.rootViewController = self.tabBar})
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                let windowView = UIApplication.sharedApplication().keyWindow!
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: errorMsg, animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let windowView = UIApplication.sharedApplication().keyWindow!
                            hideActivityIndicator(windowView)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let windowView = UIApplication.sharedApplication().keyWindow!
                        hideActivityIndicator(windowView)
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    let windowView = UIApplication.sharedApplication().keyWindow!
                    hideActivityIndicator(windowView)
                })
                
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                
                return
            }
        }
        task.resume()
    }
    
    @IBAction func backPressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

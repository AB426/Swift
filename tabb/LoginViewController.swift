//
//  LoginViewController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 21..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginBack: UIView!
    var loginScroll : UIScrollView!
    
    var loginEmail : UITextField!
    var loginPass : UITextField!
    
    private var tabBar: TabBarController!
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var deviceToken: String!
    var facebookId : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pref.setValue(0, forKey: "checkinId")
        
        tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
        loginScroll = UIScrollView()
        loginScroll.scrollEnabled = true
        loginScroll.contentSize = self.view.frame.size
        loginScroll.frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 736) / 736)
        loginBack.addSubview(loginScroll)

        let tabbLogo = UIImageView(image: UIImage(named: "logo"))
        tabbLogo.frame = CGRectMake((screen.size.width * 165) / 414, (screen.size.height * 178) / 736, (screen.size.width * 84) / 414, (screen.size.height * 84) / 736)
        loginScroll.addSubview(tabbLogo)

        let faceBookView = UIView()
        faceBookView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 380) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        faceBookView.backgroundColor = UIColorFromHex(0x3d5699, alpha: 0.7)
        faceBookView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        loginScroll.addSubview(faceBookView)

        let faceBookLogo = UIImageView(image: UIImage(named: "login_facebook"))
        faceBookLogo.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736, (screen.size.width * 38) / 414, (screen.size.height * 38) / 736)
        faceBookView.addSubview(faceBookLogo)
        
        let faceBookTitle = UILabel()
        faceBookTitle.frame = CGRectMake((screen.size.width * 90) / 414, (screen.size.height * 11) / 736, (screen.size.width * 212) / 414, (screen.size.height * 38) / 736)
        faceBookTitle.text = "Login with Facebook"
        faceBookTitle.textColor = UIColor.whiteColor()
        faceBookTitle.font = UIFont(name: latoBold, size: (screen.size.width * 18) / 414)
        faceBookTitle.textAlignment = .Center
        faceBookView.addSubview(faceBookTitle)
        
        let faceBookBtn = UIButton()
        faceBookBtn.frame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        faceBookBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        faceBookBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.4)), forState: .Highlighted)
        faceBookBtn.layer.cornerRadius = (screen.size.width * 3.5) / 414
        faceBookBtn.addTarget(self, action: "btnFBLoginPressed:", forControlEvents: .TouchUpInside)
        faceBookView.addSubview(faceBookBtn)
        
        loginEmail = UITextField()
        loginEmail.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 452) / 736, (screen.size.width * 392) / 414, (screen.size.height * 52) / 736)
        loginEmail.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        loginEmail.layer.borderWidth = (screen.size.width * 1) / 414
        loginEmail.layer.borderColor = UIColorFromHex(0x7f7868, alpha: 1.0).CGColor
        loginEmail.roundCorners(([.TopRight, .TopLeft]), radius: (screen.size.width * 3.5) / 414)
        loginEmail.textAlignment = .Center
        loginEmail.textColor = UIColor.whiteColor()
        loginEmail.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        loginEmail.attributedPlaceholder = NSAttributedString(string:"Login with E-mail",
            attributes:[NSForegroundColorAttributeName: UIColorFromHex(0xffffff, alpha: 0.6)])
        loginEmail.delegate = self
        loginEmail.keyboardType = UIKeyboardType.EmailAddress
        loginScroll.addSubview(loginEmail)
        
        loginPass = UITextField()
        loginPass.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 503) / 736, (screen.size.width * 392) / 414, (screen.size.height * 52) / 736)
        loginPass.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        loginPass.roundCorners(([.BottomRight, .BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        loginPass.layer.borderWidth = (screen.size.width * 1) / 414
        loginPass.layer.borderColor = UIColorFromHex(0x7f7868, alpha: 1.0).CGColor
        loginPass.textAlignment = .Center
        loginPass.textColor = UIColor.whiteColor()
        loginPass.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        loginPass.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColorFromHex(0xffffff, alpha: 0.6)])
        loginPass.delegate = self
        loginPass.secureTextEntry = true
        loginScroll.addSubview(loginPass)
 
        let JoinView = UIView()
        JoinView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 566) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        JoinView.backgroundColor = UIColorFromHex(0xc13939, alpha: 0.7)
        JoinView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        loginScroll.addSubview(JoinView)
        
        let joinLogo = UIImageView(image: UIImage(named: "login_tabb"))
        joinLogo.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736, (screen.size.width * 38) / 414, (screen.size.height * 38) / 736)
        JoinView.addSubview(joinLogo)
        
        let joinTitle = UILabel()
        joinTitle.frame = CGRectMake((screen.size.width * 90) / 414, (screen.size.height * 11) / 736, (screen.size.width * 212) / 414, (screen.size.height * 38) / 736)
        joinTitle.text = "Join Us"
        joinTitle.textColor = UIColor.whiteColor()
        joinTitle.font = UIFont(name: latoBold, size: (screen.size.width * 18) / 414)
        joinTitle.textAlignment = .Center
        JoinView.addSubview(joinTitle)
        
        let joinBtn = UIButton()
        joinBtn.frame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        joinBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        joinBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.4)), forState: .Highlighted)
        joinBtn.layer.cornerRadius = (screen.size.width * 3.5) / 414
        joinBtn.addTarget(self, action: "tabbJoinAction:", forControlEvents: .TouchUpInside)
        JoinView.addSubview(joinBtn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
//        if(pref.objectForKey("deviceToken") as? String == nil) {
//            var deviceToken = ""
//        } else {
//            var deviceToken = pref.objectForKey("deviceToken") as! String
//            customPop.showInView(self.view, withMessage: deviceToken, animated: true)
//        }
        
    }
    
    func test(sender: AnyObject?) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
            self.tabBar.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            let window = UIApplication.sharedApplication().windows[0]
            UIView.transitionFromView(window.rootViewController!.view,toView: self.tabBar.view,
                duration: 0.65,options: .TransitionCrossDissolve,
                completion: {finished in window.rootViewController = self.tabBar})
        })
    }
    
    func tabbJoinAction(sender: AnyObject?) {
        //회원가입 화면
        self.performSegueWithIdentifier("joinSegue", sender: sender)
    }
    
    func facebookLogin(sender: AnyObject?) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.loginEmailMethod()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if(showCheck == true) {
            return;
        }
       
        showCheck = true
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //self.loginScroll.frame.origin.y -= keyboardSize.size.height
            //self.loginScroll.frame.size.height -= keyboardSize.height
            //self.loginScroll.contentSize.height += keyboardSize.height
            
            self.loginScroll.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            self.loginScroll.contentOffset.y += keyboardSize.size.height

        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        //self.view.frame.origin.y += 160
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            self.loginScroll.frame.origin.y += keyboardSize.size.height
//            //self.loginScroll.frame.size.height += keyboardSize.height
//            self.loginScroll.contentSize.height -= keyboardSize.height
            
            self.loginScroll.contentOffset.y -= keyboardSize.size.height
            self.loginScroll.contentInset = UIEdgeInsetsMake(0, 0, -keyboardSize.height, 0)
        }
        
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func btnFBLoginPressed(sender: AnyObject) {

        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["public_profile"],
            fromViewController:self, //<=== new addition, self is the view controller where you're calling this method.
            handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                
                if ((error) != nil)
                {
                    customPop.showInView(self.view, withMessage: "Facebook 로그인을 진행하지 못하였습니다. 다시 시도하여 주시기 바랍니다.", animated: true)
                }
                else if result.isCancelled {
                    customPop.showInView(self.view, withMessage: "Facebook 로그인을 취소하였습니다.", animated: true)
                }
                else {
                    self.getFBUserData()
                }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let facebookProfile = result as! NSDictionary
                    self.facebookId = facebookProfile.objectForKey("id") as! String
                    print(facebookProfile)
                    print((facebookProfile.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        let window = UIApplication.sharedApplication().keyWindow!
                        showActivityIndicator(window)
                    })
                    
                    
                    if let url = NSURL(string: (facebookProfile.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!) {
                        let request = NSURLRequest(URL: url)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                            if let imageData = data as NSData? {
                                
                                userProfileImage = imageResize(UIImage(data: imageData)!, sizeChange: CGSize(width: (screen.size.width * 150) / 414, height: (screen.size.height * 150) / 736))
                                
                                
                                let newPost: NSDictionary = ["email": "", "authType" : "FACEBOOK", "name" : facebookProfile.objectForKey("name") as! String, "facebook" : self.facebookId]
                                self.tabbJoin(newPost)
                            }
                        }
                    }

                }
            })
        }
    }
    
    func loginEmailMethod() {
        if(!isValidEmail(loginEmail.text!)) {
            customPop.showInView(self.view, withMessage: "이메일주소 형식이 올바르지 않습니다.", animated: true)
            return;
        }
        
        if(loginPass.text == "") {
            customPop.showInView(self.view, withMessage: "비밀번호를 입력하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        
        if(pref.objectForKey("deviceToken") as? String == nil) {
            deviceToken = ""
        } else {
            deviceToken = pref.objectForKey("deviceToken") as! String
        }
        //deviceToken = pref.objectForKey("deviceToken") as! String
        let identifier: String = pref.objectForKey("identifier") as! String
        
        
        let newPost: NSDictionary = ["email": loginEmail.text!, "password": loginPass.text!, "authType" : "EMAIL", "osType" : "IPHONE", "identifier" : identifier, "token" : deviceToken]
        
        pref.setValue(false, forKey: "snsCheck")
        pref.setValue(loginEmail.text!, forKey: "email")
        
        self.tabbLogin(newPost);
        
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            let window = UIApplication.sharedApplication().keyWindow!
            showActivityIndicator(window)
        })
    }
    
    func tabbLogin(newPost: NSDictionary) {

        let url: String = serverURL + "guest/user/login"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        
        
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

                            if(post["data"]?.objectForKey("checkinId") is NSNull) {
                                let tempId = post["data"]?.objectForKey("checkinId") as! NSNull
                                print(tempId)
                                checkinId = 0
                                pref.setValue(0, forKey: "checkinId")
                                if(pref.objectForKey("restaurantId") != nil) {
                                    pref.removeObjectForKey("restaurantId")
                                }
                                if(pref.objectForKey("cartId") != nil) {
                                    pref.removeObjectForKey("cartId")
                                }
                            } else {
                                let tempId = post["data"]?.objectForKey("checkinId") as! Double
                                let tempRestaurantId = post["data"]?.objectForKey("restaurantId") as! Double
                                print(tempId)
                                checkinId = tempId
                                restaurantId = tempRestaurantId
                                pref.setValue(tempId, forKey: "checkinId")
                                pref.setValue(restaurantId, forKey: "restaurantId")
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
                            
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let windowView = UIApplication.sharedApplication().keyWindow!
                        hideActivityIndicator(windowView)
                        
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
                    
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
    }
    
    func tabbJoin(newPost: NSDictionary) {

        let url: String = serverURL + "guest/user/regUser"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)

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
                            
                            userId = post["data"]?.objectForKey("userId") as? Double
                            pref.setValue(userId, forKey: "userId")
                            pref.setValue(true, forKey: "snsCheck")
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                if(pref.objectForKey("deviceToken") as? String == nil) {
                                    self.deviceToken = ""
                                } else {
                                    self.deviceToken = pref.objectForKey("deviceToken") as! String
                                }
                                //deviceToken = pref.objectForKey("deviceToken") as! String
                                let identifier: String = pref.objectForKey("identifier") as! String
                                
                                
                                let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                                
                                self.tabbLogin(newPost);
                            })
                        } else if(status == 104) {
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                if(pref.objectForKey("deviceToken") as? String == nil) {
                                    self.deviceToken = ""
                                } else {
                                    self.deviceToken = pref.objectForKey("deviceToken") as! String
                                }
                                //deviceToken = pref.objectForKey("deviceToken") as! String
                                let identifier: String = pref.objectForKey("identifier") as! String
                                
                                
                                let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                                
                                self.tabbLogin(newPost);
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
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
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
    
    func tabbJoinSendImage() {
        if(pref.objectForKey("deviceToken") as? String == nil) {
            self.deviceToken = ""
        } else {
            self.deviceToken = pref.objectForKey("deviceToken") as! String
        }
        //deviceToken = pref.objectForKey("deviceToken") as! String
        let identifier: String = pref.objectForKey("identifier") as! String
        
        
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
                            
                            userId = post["data"]?.objectForKey("userId") as? Double
                            pref.setValue(userId, forKey: "userId")
                            pref.setValue(true, forKey: "snsCheck")
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here

                                let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                                
                                self.tabbLogin(newPost);
                            })
                        } else if(status == 104) {
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here

                                let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                                
                                self.tabbLogin(newPost);
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                                
                                self.tabbLogin(newPost);
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // code here
                            
                            let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                            
                            self.tabbLogin(newPost);
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        
                        let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                        
                        self.tabbLogin(newPost);
                    })
                    
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    // code here
                    
                    let newPost: NSDictionary = ["facebook" : self.facebookId, "authType" : "FACEBOOK", "osType" : "IPHONE", "identifier" : identifier, "token" : self.deviceToken]
                    
                    self.tabbLogin(newPost);
                })
                
                return
            }
        }
        task.resume()
    }
    
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
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
//    func photoDataToFormData(parameters: String, data:NSData, boundary:String, fileName:String) -> NSData {
//        let fullData = NSMutableData()
//        
//        // 0 - Boundary should start with --
//        let lineZero = "--" + boundary + "\r\n"
//        fullData.appendData(lineZero.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//        fullData.appendData(("Content-Disposition: form-data; name=\"regData\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//        fullData.appendData(("\(parameters)\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//        
//        // 1 - Boundary should start with --
//        let lineOne = "--" + boundary + "\r\n"
//        fullData.appendData(lineOne.dataUsingEncoding(
//            NSUTF8StringEncoding,
//            allowLossyConversion: false)!)
//        
//        // 2
//        let lineTwo = "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
//        NSLog(lineTwo)
//        fullData.appendData(lineTwo.dataUsingEncoding(
//            NSUTF8StringEncoding,
//            allowLossyConversion: false)!)
//        
//        // 3
//        let lineThree = "Content-Type: image/jpg\r\n\r\n"
//        fullData.appendData(lineThree.dataUsingEncoding(
//            NSUTF8StringEncoding,
//            allowLossyConversion: false)!)
//        
//        // 4
//        fullData.appendData(data)
//        
//        // 5
//        let lineFive = "\r\n"
//        fullData.appendData(lineFive.dataUsingEncoding(
//            NSUTF8StringEncoding,
//            allowLossyConversion: false)!)
//        
//        // 6 - The end. Notice -- at the start and at the end
//        let lineSix = "--" + boundary + "--\r\n"
//        fullData.appendData(lineSix.dataUsingEncoding(
//            NSUTF8StringEncoding,
//            allowLossyConversion: false)!)
//        
//        return fullData
//    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}



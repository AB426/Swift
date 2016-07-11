//
//  AccountController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 21..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class AccountController: UIViewController {
    
    @IBOutlet weak var accountBack: UIView!

    var search : SearchViewController!
    
    var loginView : LoginViewController!
    
    var pictureVersion = -1
    var tempPictureVersion = 0
    
    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginView = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        
        self.getMyProfile()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if(profileChangeCheck) {
            profileChangeCheck = false
            self.getMyProfile()
        }
        
//        
//        if(historyGoChk) {
//            historyGoChk = false
//            self.goHistory(nil)
//        }
        //self.updateDisplay()
    }
    
    func updateDisplay() {
        
        let myProfile = UIImageView()
        myProfile.frame = CGRectMake((screen.size.width * 161) / 414, (screen.size.height * 58) / 736, (screen.size.width * 92) / 414, (screen.size.height * 92) / 736)
        myProfile.layer.cornerRadius = myProfile.frame.size.height / 2
        myProfile.clipsToBounds = true
        myProfile.image = UIImage(named: "icon_nophoto")
        
        
        accountBack.addSubview(myProfile)
        
        if(pictureVersion == tempPictureVersion) {
            myProfile.image = profileImage
            
            if(imageList.count > 0) {
                imageList.replaceObjectAtIndex(0, withObject: profileImage)
                grayImageList.replaceObjectAtIndex(0, withObject: UIImage.convertToGrayScale(profileImage))
            }
        } else {
            let loadingView = UIView()
            loadingView.frame = CGRectMake((screen.size.width * 161) / 414, (screen.size.height * 58) / 736, (screen.size.width * 92) / 414, (screen.size.height * 92) / 736)
            loadingView.backgroundColor = UIColor.clearColor()
            accountBack.addSubview(loadingView)
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 12) / 414, (screen.size.height * 12) / 736);
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                loadingView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
            })
            if let url = NSURL(string: (profile.objectForKey("picture") as? String)!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        myProfile.image = UIImage(data: imageData)
                        profileImage = UIImage(data: imageData)!
                        
                        self.pictureVersion = profile.objectForKey("pictureVersion") as! Int
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                            
                            if(imageList.count > 0) {
                                imageList.replaceObjectAtIndex(0, withObject: profileImage)
                                grayImageList.replaceObjectAtIndex(0, withObject: UIImage.convertToGrayScale(profileImage))
                            }
                            
                        })
                    }
                }
            }
        }
        
        let myProfileName = UILabel()
        myProfileName.frame = CGRectMake((screen.size.width * 120) / 414, (screen.size.height * 157) / 736, (screen.size.width * 174) / 414, (screen.size.height * 25) / 736)
        myProfileName.text = profile.objectForKey("name") as? String
//        if(members.count > 0) {
//            myProfileName.text = members[0].objectForKey("userName") as? String
//        }
        
        
        myProfileName.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        myProfileName.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        myProfileName.textAlignment = .Center
        accountBack.addSubview(myProfileName)
        
        
        let myProfileView = UIView()
        myProfileView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 197) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        myProfileView.backgroundColor = UIColorFromHex(0x333333, alpha: 1.0)
        myProfileView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        accountBack.addSubview(myProfileView)
        
        let profileIcon = UIImageView(image: UIImage(named: "icon_myprofile"))
        profileIcon.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 17) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        myProfileView.addSubview(profileIcon)
        
        let profileTitle = UILabel()
        profileTitle.frame = CGRectMake((screen.size.width * 67) / 414, (screen.size.height * 17) / 736, (screen.size.width * 212) / 414, (screen.size.height * 27) / 736)
        profileTitle.text = "My Profile"
        profileTitle.textColor = UIColor.whiteColor()
        profileTitle.font = UIFont(name: latoThin, size: (screen.size.width * 18) / 414)
        profileTitle.textAlignment = .Left
        myProfileView.addSubview(profileTitle)
        
        let profileBtn = UIButton()
        profileBtn.frame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        profileBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        profileBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.4)), forState: .Highlighted)
        profileBtn.layer.cornerRadius = (screen.size.width * 3.5) / 414
        profileBtn.addTarget(self, action: "modifyMyProfile:", forControlEvents: .TouchUpInside)
        myProfileView.addSubview(profileBtn)
        
        let historyView = UIView()
        historyView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 269) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        historyView.backgroundColor = UIColorFromHex(0x333333, alpha: 1.0)
        historyView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        accountBack.addSubview(historyView)
        
        let historyIcon = UIImageView(image: UIImage(named: "icon_history"))
        historyIcon.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 17) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        historyView.addSubview(historyIcon)
        
        let historyTitle = UILabel()
        historyTitle.frame = CGRectMake((screen.size.width * 67) / 414, (screen.size.height * 17) / 736, (screen.size.width * 212) / 414, (screen.size.height * 27) / 736)
        historyTitle.text = "History"
        historyTitle.textColor = UIColor.whiteColor()
        historyTitle.font = UIFont(name: latoThin, size: (screen.size.width * 18) / 414)
        historyTitle.textAlignment = .Left
        historyView.addSubview(historyTitle)
        
        let historyBtn = UIButton()
        historyBtn.frame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        historyBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        historyBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.4)), forState: .Highlighted)
        historyBtn.layer.cornerRadius = (screen.size.width * 3.5) / 414
        historyBtn.addTarget(self, action: "goHistory:", forControlEvents: .TouchUpInside)
        historyView.addSubview(historyBtn)
        
        let pointView = UIView()
        pointView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 341) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        pointView.backgroundColor = UIColorFromHex(0x333333, alpha: 1.0)
        pointView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        accountBack.addSubview(pointView)
        
        let pointIcon = UIImageView(image: UIImage(named: "icon_point"))
        pointIcon.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 17) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        pointView.addSubview(pointIcon)
        
        let pointTitle = UILabel()
        pointTitle.frame = CGRectMake((screen.size.width * 67) / 414, (screen.size.height * 17) / 736, (screen.size.width * 212) / 414, (screen.size.height * 27) / 736)
        pointTitle.text = "TABBCredit"
        pointTitle.textColor = UIColor.whiteColor()
        pointTitle.font = UIFont(name: latoThin, size: (screen.size.width * 18) / 414)
        pointTitle.textAlignment = .Left
        pointView.addSubview(pointTitle)
        
        let pointBtn = UIButton()
        pointBtn.frame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        pointBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        pointBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.4)), forState: .Highlighted)
        pointBtn.layer.cornerRadius = (screen.size.width * 3.5) / 414
        pointBtn.addTarget(self, action: "goQuickPay:", forControlEvents: .TouchUpInside)
        pointView.addSubview(pointBtn)
        
        let signOutView = UIView()
        signOutView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 413) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        signOutView.backgroundColor = UIColorFromHex(0x333333, alpha: 1.0)
        signOutView.layer.cornerRadius = (screen.size.width * 3.5) / 414
        accountBack.addSubview(signOutView)
        
        let signOutIcon = UIImageView(image: UIImage(named: "icon_signout"))
        signOutIcon.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 17) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        signOutView.addSubview(signOutIcon)
        
        let signOutTitle = UILabel()
        signOutTitle.frame = CGRectMake((screen.size.width * 67) / 414, (screen.size.height * 17) / 736, (screen.size.width * 212) / 414, (screen.size.height * 27) / 736)
        signOutTitle.text = "Sign Out"
        signOutTitle.textColor = UIColor.whiteColor()
        signOutTitle.font = UIFont(name: latoThin, size: (screen.size.width * 18) / 414)
        signOutTitle.textAlignment = .Left
        signOutView.addSubview(signOutTitle)
        
        let signOutBtn = UIButton()
        signOutBtn.frame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736)
        signOutBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        signOutBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.4)), forState: .Highlighted)
        signOutBtn.layer.cornerRadius = (screen.size.width * 3.5) / 414
        signOutBtn.addTarget(self, action: "signOut:", forControlEvents: .TouchUpInside)
        signOutView.addSubview(signOutBtn)
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        accountBack.addSubview(callView)
        
        let callImage = UIImageView(image: UIImage(named: "icon_call"))
        callImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
        callView.addSubview(callImage)
        
        let callBtn = UIButton()
        callBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callBtn.backgroundColor = UIColor.clearColor()
        callBtn.layer.cornerRadius = callBtn.frame.size.width / 2
        callBtn.clipsToBounds = true
        callBtn.addTarget(self, action: "callAction:", forControlEvents: .TouchUpInside)
        callBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        callBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
        callView.addSubview(callBtn)
        
        dispatch_async(dispatch_get_main_queue(), {
            hideActivityIndicator(windowView)
            
        })
        
    }
    
    func getMyProfile() {
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
            
        })

        let url: String = serverURL + "user/profile/search"
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
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            profile = post["data"] as! NSDictionary
                            pref.setValue(profile.objectForKey("name") as! String, forKey: "userName")
                            
                            self.tempPictureVersion = profile.objectForKey("pictureVersion") as! Int
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.updateDisplay()
                                
                            })
                            
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
    }
    
    func modifyMyProfile(sender: AnyObject?) {
        self.performSegueWithIdentifier("modify", sender: sender)
    }
    func goHistory(sender: AnyObject?) {
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        let url: String = serverURL + "user/bill/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let today = NSDate()
        let formatYear = NSDateFormatter()
        formatYear.dateFormat = "yyyy";
        
        let formatMonth = NSDateFormatter()
        formatMonth.dateFormat = "MM";
        
        searchYear = Int.init(formatYear.stringFromDate(today))!
        searchMonth = Int.init(formatMonth.stringFromDate(today))!
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "year" : searchYear, "month" : searchMonth]
        
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
                            
                            let data = post["data"] as! NSDictionary
                            
                            let chk: AnyObject? = data.valueForKey("items")
                            
                            if(chk?.count == 0) {
                                
                                historyData = NSDictionary()
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("history", sender: nil)
                                })
                                
                            } else {
                                historyData = post["data"] as! NSDictionary
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("history", sender: nil)
                                })
                            }
                            
                            
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                                                print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
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
        
        dispatch_async(dispatch_get_main_queue(), {
            hideActivityIndicator(windowView)
        })
    }
    func goQuickPay(sender: AnyObject?) {
        
        let url: String = serverURL + "user/point/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let today = NSDate()
        let formatYear = NSDateFormatter()
        formatYear.dateFormat = "yyyy";
        
        let formatMonth = NSDateFormatter()
        formatMonth.dateFormat = "MM";
        
        searchYear = Int.init(formatYear.stringFromDate(today))!
        searchMonth = Int.init(formatMonth.stringFromDate(today))!
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "lastYear" : searchYear, "lastMonth" : searchMonth]
        
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
                            
                            let data = post["data"] as! NSDictionary
                            guickPayData = data
                            
                            let chk: AnyObject? = data.valueForKey("items")
                            
                            if(chk?.count == 0) {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("quickPay", sender: sender)
                                })
                                
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("quickPay", sender: sender)
                                })
                            }
                            
                            
                            
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
        
        
    }
    func signOut(sender: AnyObject?) {
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
                            
                            let tempCheckinId = pref.objectForKey("checkinId") as! Double
                            
                            if(tempCheckinId > 0) {
                                restaurantId = pref.objectForKey("restaurantId") as! Double
                                if(pref.objectForKey("cartId") != nil) {
                                    cartId = pref.objectForKey("cartId") as! Double
                                }
                            }

                            for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
                                NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
                            }
                            
                            pref.setObject(deviceToken, forKey: "deviceToken")
                            pref.setObject(identifier, forKey: "identifier")
                            pref.setObject(checkinId, forKey: "tempCheckinId")
                            if(tempCheckinId > 0) {
                                pref.setObject(restaurantId, forKey: "restaurantId")
                                pref.setObject(cartId, forKey: "cartId")
                            }

                            print(pref.objectForKey("deviceToken") as! String)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginNavi = storyboard.instantiateViewControllerWithIdentifier("loginNavi") as! UINavigationController
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                
                                checkinId = 0
                                restaurantId = 0
                                cartId = 0
                                members = NSArray()
                                cartItems = NSArray()
                                paymentItems = NSArray()
                                checkinChk = false
                                searchCheck = false
                                likeChk = false
                                
                                loginNavi.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                                let window = UIApplication.sharedApplication().windows[0]
                                UIView.transitionFromView(window.rootViewController!.view,toView: loginNavi.view,
                                    duration: 0.65,options: .TransitionCrossDissolve,
                                    completion: {finished in window.rootViewController = loginNavi})
                            })
                            
                            
                        } else if(status == HAVE_PAY_BILL){
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "아직 결제를 진행하지 않았습니다. 결제 진행 후에 다시 시도하여 주시기 바랍니다.", animated: true)
                            })
                        } else if(status == HAVE_ORDER_FOOD){
                            let errorMsg: String! = post["error"] as! String
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "아직 주문을 완료하지 않았습니다. 주문 완료 후에 다시 시도하여 주시기 바랍니다.", animated: true)
                            })
                            print(errorMsg)
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
    }
    
    func callAction(sender : AnyObject?) {
        if(checkinId == 0) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        let url: String = serverURL + "user/serviceCall/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId]
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
                        //print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            let data = post["data"] as! NSDictionary
                            serviceCallList = data.objectForKey("items") as! NSDictionary
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                hideActivityIndicator(windowView)
                                serviceCall = ServiceCallViewController(nibName: "PopupView", bundle: nil)
                                serviceCall.showInView(self.view, withMessage: "Service Call", animated: true)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                            })
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                        })
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                })
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
}

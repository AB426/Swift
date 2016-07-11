//
//  TableCheckInController.swift
//  tabb
//
//  Created by LeeDongMin on 12/2/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class TableCheckInController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mainBack: UIView!
    
    var mainName : UILabel!
    var browseName : UILabel!
    
    var tableNumber = MyTextField()
    var tableHint = UILabel()
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var barButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCount = 0
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "icon_blank"), forState: UIControlState.Normal)
        leftButton.frame = CGRectMake(0, 0, screen.size.width * 29 / 414, screen.size.height * 29 / 736)
        barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        let imageHeight: CGFloat!
        imageHeight = screen.size.height - (self.tabBarController?.tabBar.frame.size.height)! - (self.navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height - ((screen.size.height * 392) / 736) - ((screen.size.width * 11) / 414)
        
        print(imageHeight)
        
        let mainImg = UIImageView()
        mainImg.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 392) / 736)
        mainImg.clipsToBounds = true
        mainImg.contentMode = UIViewContentMode.ScaleToFill
        mainImg.layer.cornerRadius = (screen.size.height * 3.5) / 414
        mainBack.addSubview(mainImg)
        
        let loadingView = UIView()
        loadingView.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 392) / 736)
        loadingView.backgroundColor = UIColor.clearColor()
        mainBack.addSubview(loadingView)
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        dispatch_async(dispatch_get_main_queue(), {
            activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
            loadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
        })
        if let url = NSURL(string: (restaurantView.objectForKey("picture") as? String)!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    mainImg.image = UIImage(data: imageData)
                    dispatch_async(dispatch_get_main_queue(), {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    })
                }
            }
        }
        
//        let resMainBtn = UIButton()
//        resMainBtn.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 392) / 736)
//        resMainBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: UIControlState.Normal)
//        resMainBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: UIControlState.Highlighted)
//        resMainBtn.clipsToBounds = true
//        resMainBtn.layer.cornerRadius = (screen.size.height * 3.5) / 414
//        resMainBtn.addTarget(self, action: "getBrowseMenuList:", forControlEvents: UIControlEvents.TouchUpInside)
//        mainBack.addSubview(resMainBtn)
        let shadow = UIImageView(image: UIImage(named: "shadow_thumb"))
        shadow.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 392) / 736)
        shadow.clipsToBounds = true
        shadow.layer.cornerRadius = (screen.size.height * 3.5) / 414
        mainBack.addSubview(shadow)
        
        let mainHeart = UIImageView(image: UIImage(named: "icon_heart"))
        mainHeart.frame = CGRect(x: (screen.size.width * 27) / 414, y: (screen.size.width * 27) / 414, width: (screen.size.width * 29) / 414, height: (screen.size.height * 29) / 736)
        mainBack.addSubview(mainHeart)
        let mainHeartCount = UILabel()
        
        mainHeartCount.frame = CGRect(x: (screen.size.width * 43) / 414, y: (screen.size.width * 21) / 414, width: (screen.size.width * 24) / 414, height: (screen.size.height * 24) / 736)
        
        let content: NSString = (restaurantView.objectForKey("favoritesCount")?.description)!
        let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 12) / 414)])
        if(labelSize.width > ((screen.size.width * 24) / 414 )) {
            mainHeartCount.frame = CGRect(x: (screen.size.width * 43) / 414, y: (screen.size.width * 21) / 414, width: (labelSize.width + 10), height: (screen.size.height * 24) / 736)
        }
        
        mainHeartCount.backgroundColor = UIColor.redColor()
        mainHeartCount.layer.cornerRadius = mainHeartCount.frame.size.height/2
        mainHeartCount.clipsToBounds = true
        mainHeartCount.text = restaurantView.objectForKey("favoritesCount")?.description
        mainHeartCount.textColor = UIColor.whiteColor()
        mainHeartCount.font = UIFont(name: roboto, size: (screen.size.width * 12) / 414)
        mainHeartCount.adjustsFontSizeToFitWidth = true
        mainHeartCount.textAlignment = .Center
        mainBack.addSubview(mainHeartCount)
        
        if((restaurantView.objectForKey("favoritesCount") as! Int) == 0) {
            mainHeartCount.hidden = true
        }
        
        let mainMap = UIImageView(image: UIImage(named: "icon_map"))
        mainMap.frame = CGRect(x: (screen.size.width * 358) / 414, y: (screen.size.width * 27) / 414, width: (screen.size.width * 29) / 414, height: (screen.size.height * 29) / 736)
        mainBack.addSubview(mainMap)      
        
        mainName = UILabel()
        mainName.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 335) / 736, width: (screen.size.width * 190) / 414, height: (screen.size.height * 30) / 736)
        mainName.text = restaurantView.objectForKey("name") as? String
        mainName.font = UIFont(name: roboto, size: (screen.size.width * 26) / 414)
        mainName.backgroundColor = UIColor.clearColor()
        mainName.numberOfLines = 2
        //mainName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mainName.sizeToFit()
        
        //size 재조정
        mainName.frame.origin.y = ((screen.size.height * 370) / 736 - mainName.frame.size.height)
        mainName.textColor = UIColorFromHex(0xf9a212, alpha: 1.0)
        mainBack.addSubview(mainName)
        browseName = UILabel()
        browseName.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 365) / 736, width: (screen.size.width * 130) / 414, height: (screen.size.height * 25) / 736)
        browseName.text = restaurantView.objectForKey("foodTypeDescr") as? String
        browseName.font = UIFont(name: latoBold, size: (screen.size.width * 18) / 414)
        browseName.backgroundColor = UIColor.clearColor()
        //browseName.adjustsFontSizeToFitWidth = true
        browseName.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        mainBack.addSubview(browseName)
        
        let btnFace = UIImageView(image: UIImage(named: "btn_face.png"))
        btnFace.frame = CGRect(x: (screen.size.width * 292) / 414, y: (screen.size.height * 340) / 736, width: (screen.size.width * 38) / 414, height: (screen.size.width * 38) / 414)
        mainBack.addSubview(btnFace)
        let btnInsta = UIImageView(image: UIImage(named: "btn_insta.png"))
        btnInsta.frame =  CGRect(x: (screen.size.width * 347) / 414, y: (screen.size.height * 340) / 736, width: (screen.size.width * 38) / 414, height: (screen.size.width * 38) / 414)
        mainBack.addSubview(btnInsta)
        
        let mainBottom = UIView()
        mainBottom.frame = CGRect(x: 0, y: (screen.size.height * 403) / 736, width: screen.size.width, height: imageHeight)
        mainBottom.backgroundColor = UIColor.clearColor()
        mainBack.addSubview(mainBottom)
        
        let iconHeart = UIImageView(image: UIImage(named: "indi_heart_0"))
        iconHeart.frame = CGRect(x: (screen.size.width * 51) / 414, y: (screen.size.height * 80) / 736, width: (screen.size.width * 42) / 414, height: (screen.size.height * 42) / 736)
        mainBottom.addSubview(iconHeart)
        let heartCount = UILabel()
        heartCount.frame = CGRect(x: (screen.size.width * 51) / 414, y: (screen.size.height * 122) / 736, width: (screen.size.width * 42) / 414, height: (screen.size.height * 20) / 736)
        heartCount.text = restaurantView.objectForKey("favoritesCount")?.description
        heartCount.textAlignment = .Center
        heartCount.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        heartCount.adjustsFontSizeToFitWidth = true
        heartCount.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        mainBottom.addSubview(heartCount)
        
        let iconStar = UIImageView()
        iconStar.frame = CGRect(x: (screen.size.width * 320) / 414, y: (screen.size.height * 80) / 736, width: (screen.size.width * 42) / 414, height: (screen.size.height * 42) / 736)
        mainBottom.addSubview(iconStar)
        let starCount = UILabel()
        starCount.frame = CGRect(x: (screen.size.width * 320) / 414, y: (screen.size.height * 122) / 736, width: (screen.size.width * 42) / 414, height: (screen.size.height * 20) / 736)
        
        let gradeTemp = round(restaurantView.objectForKey("grade") as! Double * 10) / 10
        
        if(gradeTemp < 0.1) {
            iconStar.image = UIImage(named: "indi_star_0")
        } else if(gradeTemp > 0 && gradeTemp < 0.5){
            iconStar.image = UIImage(named: "indi_star_1")
        } else if(gradeTemp >= 0.5 && gradeTemp < 1.3){
            iconStar.image = UIImage(named: "indi_star_2")
        } else if(gradeTemp >= 1.3 && gradeTemp < 1.8){
            iconStar.image = UIImage(named: "indi_star_3")
        } else if(gradeTemp >= 1.8 && gradeTemp < 2.3){
            iconStar.image = UIImage(named: "indi_star_4")
        } else if(gradeTemp >= 2.3 && gradeTemp < 2.8){
            iconStar.image = UIImage(named: "indi_star_5")
        } else if(gradeTemp >= 2.8 && gradeTemp < 3.3){
            iconStar.image = UIImage(named: "indi_star_6")
        } else if(gradeTemp >= 3.3 && gradeTemp < 3.8){
            iconStar.image = UIImage(named: "indi_star_7")
        } else if(gradeTemp >= 3.8 && gradeTemp < 4.3){
            iconStar.image = UIImage(named: "indi_star_8")
        } else if(gradeTemp >= 4.3 && gradeTemp < 4.8){
            iconStar.image = UIImage(named: "indi_star_9")
        } else if(gradeTemp >= 4.8){
            iconStar.image = UIImage(named: "indi_star_10")
        }
        
        starCount.text = gradeTemp.description
        starCount.textAlignment = .Center
        starCount.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        starCount.adjustsFontSizeToFitWidth = true
        starCount.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        mainBottom.addSubview(starCount)
        
        let inputBack = UIView()
        inputBack.frame = CGRect(x: (screen.size.width * 124) / 414, y: (screen.size.height * 23) / 736, width: (screen.size.width * 165) / 414, height: (screen.size.height * 165) / 736)
        mainBottom.addSubview(inputBack)
        
        let inputBackImage = UIImageView(image: UIImage(named: "input_table"))
        inputBackImage.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 165) / 414, height: (screen.size.height * 165) / 736)
        inputBack.addSubview(inputBackImage)
        
        tableHint.frame = CGRect(x: (screen.size.width * 22) / 414, y: (screen.size.height * 37) / 736, width: (screen.size.width * 120) / 414, height: (screen.size.height * 90) / 736)
        self.tableHint.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        self.tableHint.textColor = UIColorFromHex(0x555555, alpha: 0.8)
        self.tableHint.textAlignment = .Center
        self.tableHint.text = "Enter your\nTable Number\nfor Check-in"
        self.tableHint.numberOfLines = 0
        inputBack.addSubview(self.tableHint)
        
        self.tableNumber.frame = CGRect(x: (screen.size.width * 22) / 414, y: (screen.size.height * 67) / 736, width: (screen.size.width * 120) / 414, height: (screen.size.height * 30) / 736)
        self.tableNumber.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        self.tableNumber.backgroundColor = UIColor.clearColor()
        self.tableNumber.textColor = UIColorFromHex(0x555555, alpha: 1.0)
        self.tableNumber.delegate = self
        self.tableNumber.textAlignment = .Center
        self.tableNumber.keyboardType = UIKeyboardType.NumberPad
        inputBack.addSubview(self.tableNumber)
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.BlackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "checkInTable")
        ]
        
        numberToolbar.sizeToFit()
        
        self.tableNumber.inputAccessoryView = numberToolbar
    }
    
    func cancel () {
        self.tableNumber.text=""
        self.tableHint.hidden = false
        self.tableNumber.resignFirstResponder()
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.tableHint.hidden = true
        
        if(showCheck == true) {
            return;
        }
        
        showCheck = true
        
        self.view.frame.origin.y -= 160
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if(self.tableNumber.text == "") {
            self.tableHint.hidden = false
        }
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        self.view.frame.origin.y += 160
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
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if(self.tableNumber.text == "") {
            self.tableHint.hidden = false
        }
    }
    
    
    func checkInTable() {
        self.tableNumber.resignFirstResponder()
        let url: String = serverURL + "user/restaurant/checkin"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String

        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId, "tableNum" : self.tableNumber.text!]
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
                            checkinId = (post["data"] as! NSDictionary).objectForKey("checkinId") as! Double
                            pref.setValue(checkinId, forKey: "checkinId")
                            pref.setValue(restaurantId, forKey: "restaurantId")
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                self.getServiceCallList()
                                
                                self.getBrowseMenuList(nil);
                            })
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
    
    func getBrowseMenuList(sender: AnyObject?) {
        let url: String = serverURL + "user/category/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId, "lastId" : 0, "size" : 30]
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
                            //성공
                            let data = post["data"] as! NSDictionary
                            
                            let chk: AnyObject? = data.valueForKey("categories")
                            
                            if(chk?.count == 0) {
                                
                            } else {
                                //hideActivityIndicator(self.view)
                                //print(data.valueForKey("categories"))
                                categories = data.valueForKey("categories") as! NSArray
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    // code here
                                    checkinChk = true
                                    self.performSegueWithIdentifier("checkinBrowseMenu", sender: nil)
                                })
                            }
                        } else if(status == 701){
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Please check the table number.", animated: true)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
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
                    print("response was not 200: \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
        
    }
    
    func getServiceCallList() {
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
                                
                                
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
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
                    print("response was not 200: \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

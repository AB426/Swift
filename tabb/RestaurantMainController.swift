//
//  RestaurantMainController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 29..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class RestaurantMainController: UIViewController {

    @IBOutlet weak var mainBack: UIView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var mainName : UILabel!
    var browseName : UILabel!
    var mainHeartCount : UILabel!
    
    var search : SearchViewController!
    var restaurantMap : RestaurantMapController!
    
    var mainHeart : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageHeight: CGFloat!
        imageHeight = screen.size.height - (self.tabBarController?.tabBar.frame.size.height)! - (self.navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height - ((screen.size.height * 392) / 736) - ((screen.size.width * 11) / 414)
        
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
        
        let resMainBtn = UIButton()
        resMainBtn.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 392) / 736)
        resMainBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: UIControlState.Normal)
        resMainBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: UIControlState.Highlighted)
        resMainBtn.clipsToBounds = true
        resMainBtn.layer.cornerRadius = (screen.size.height * 3.5) / 414
        resMainBtn.addTarget(self, action: "getBrowseMenuList:", forControlEvents: UIControlEvents.TouchUpInside)
        mainBack.addSubview(resMainBtn)
        let shadow = UIImageView(image: UIImage(named: "shadow_thumb"))
        shadow.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 392) / 736)
        shadow.clipsToBounds = true
        shadow.layer.cornerRadius = (screen.size.height * 3.5) / 414
        mainBack.addSubview(shadow)
        
        mainHeart = UIButton()
        
        let like = restaurantView.valueForKey("like") as? Bool
        if(like == true) {
            mainHeart.setBackgroundImage(UIImage(named: "icon_heart_r")?.alpha(1.0), forState: .Normal)
        } else {
            mainHeart.setBackgroundImage(UIImage(named: "icon_heart")?.alpha(0.6), forState: .Normal)
        }

        mainHeart.frame = CGRect(x: (screen.size.width * 27) / 414, y: (screen.size.width * 27) / 414, width: (screen.size.width * 29) / 414, height: (screen.size.height * 29) / 736)
        mainHeart.addTarget(self, action: "sendFavoriteRestaurant:", forControlEvents: .TouchUpInside)
        mainBack.addSubview(mainHeart)
        mainHeartCount = UILabel()
        
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
        
        let mainMap = UIButton()
        mainMap.setBackgroundImage(UIImage(named: "icon_map")?.alpha(0.6), forState: .Normal)
        mainMap.frame = CGRect(x: (screen.size.width * 358) / 414, y: (screen.size.width * 27) / 414, width: (screen.size.width * 29) / 414, height: (screen.size.height * 29) / 736)
        mainMap.addTarget(self, action: "restaurantMap:", forControlEvents: .TouchUpInside)
        mainBack.addSubview(mainMap)

        mainName = UILabel()
        mainName.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 305) / 736, width: (screen.size.width * 240) / 414, height: (screen.size.height * 60) / 736)
        mainName.text = restaurantView.objectForKey("name") as? String
        mainName.font = UIFont(name: roboto, size: (screen.size.width * 26) / 414)
        mainName.backgroundColor = UIColor.clearColor()
        mainName.numberOfLines = 2
        //mainName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mainName.sizeToFit()
        
        //size 재조정
        mainName.frame.origin.y = ((screen.size.height * 370) / 736 - mainName.frame.size.height)
        
        //mainName.adjustsFontSizeToFitWidth = true
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
        
        let btnFace = UIButton()
        btnFace.frame =  CGRect(x: (screen.size.width * 292) / 414, y: (screen.size.height * 340) / 736, width: (screen.size.width * 38) / 414, height: (screen.size.width * 38) / 414)
        let face = UIImage(named: "btn_face.png")
        btnFace.setBackgroundImage(face, forState: .Normal)
        btnFace.addTarget(self, action: "openFacebook:", forControlEvents: .TouchUpInside)
        mainBack.addSubview(btnFace)
        let btnInsta = UIButton()
        btnInsta.frame =  CGRect(x: (screen.size.width * 347) / 414, y: (screen.size.height * 340) / 736, width: (screen.size.width * 38) / 414, height: (screen.size.width * 38) / 414)
        let insta = UIImage(named: "btn_insta.png")
        btnInsta.setBackgroundImage(insta, forState: .Normal)
        btnInsta.addTarget(self, action: "openInstagram:", forControlEvents: .TouchUpInside)
        mainBack.addSubview(btnInsta)
        
        let mainBottom = UIView()
        mainBottom.frame = CGRect(x: 0, y: (screen.size.height * 403) / 736, width: screen.size.width, height: imageHeight)
        mainBottom.backgroundColor = UIColor.clearColor()
        mainBack.addSubview(mainBottom)
        
        let propertyTitleHeight = (screen.size.height * 35) / 736
        let propertyHeight = (screen.size.height * 20) / 736
        var count : CGFloat = 0

        for (myKey, myValue) in (restaurantView.objectForKey("properties") as? NSDictionary)! {
            print("\(myKey) \t \(myValue)")

            let keyTitle = UILabel()
            keyTitle.frame = CGRect(x: (screen.size.width * 29) / 414, y: (propertyTitleHeight * count) + propertyHeight, width: (screen.size.width * 150) / 414, height: propertyHeight)
            keyTitle.text = myKey as? String
            keyTitle.font = UIFont(name: latoBold, size: (screen.size.width * 14) / 414)
            keyTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
            mainBottom.addSubview(keyTitle)
            
            
//            let content: NSString = (myValue.description)!
//            let height = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 14) / 414)])
            
            let valueTitle = UILabel()
            valueTitle.frame = CGRect(x: (screen.size.width * 213) / 414, y: (propertyTitleHeight * count) + propertyHeight, width: (screen.size.width * 150) / 414, height: propertyHeight)
            valueTitle.text = myValue as? String
            valueTitle.font = UIFont(name: latoBold, size: (screen.size.width * 14) / 414)
            valueTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
            valueTitle.textAlignment = .Left
            valueTitle.numberOfLines = 2
            valueTitle.sizeToFit()
            mainBottom.addSubview(valueTitle)

            
            count++
        }
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        mainBack.addSubview(callView)
        
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
        
//        let hoursTitle = UILabel()
//        hoursTitle.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 440) / 736, width: (screen.size.width * 150) / 414, height: (screen.size.height * 20) / 736)
//        hoursTitle.text = "BUSINESS HOURS"
//        hoursTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
//        hoursTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
//        mainBack.addSubview(hoursTitle)
//        
//        let paymentTitle = UILabel()
//        paymentTitle.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 475) / 736, width: (screen.size.width * 150) / 414, height: (screen.size.height * 20) / 736)
//        paymentTitle.text = "PAYMENT OPTION"
//        paymentTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
//        paymentTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
//        mainBack.addSubview(paymentTitle)
//        
//        let parkingTitle = UILabel()
//        parkingTitle.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 510) / 736, width: (screen.size.width * 150) / 414, height: (screen.size.height * 20) / 736)
//        parkingTitle.text = "VALET PARKING"
//        parkingTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
//        parkingTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
//        mainBack.addSubview(parkingTitle)
//        
//        let deliveryTitle = UILabel()
//        deliveryTitle.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 545) / 736, width: (screen.size.width * 150) / 414, height: (screen.size.height * 20) / 736)
//        deliveryTitle.text = "DELIVERY"
//        deliveryTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
//        deliveryTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
//        mainBack.addSubview(deliveryTitle)
//        
//        let pickUpTitle = UILabel()
//        pickUpTitle.frame = CGRect(x: (screen.size.width * 29) / 414, y: (screen.size.height * 580) / 736, width: (screen.size.width * 150) / 414, height: (screen.size.height * 20) / 736)
//        pickUpTitle.text = "PICKUP ORDER"
//        pickUpTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
//        pickUpTitle.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
//        mainBack.addSubview(pickUpTitle)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(searchCheck == true) {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
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
    
    @IBAction func backPressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)
    }
    
    func nextBrowseList(sender: AnyObject?) {
        
    }
    
    func getBrowseMenuList(sender: AnyObject?) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("resBrowse", sender: sender)
        })
    
    }
    
    func sendFavoriteRestaurant(sender: AnyObject?) {
        let url: String = serverURL + "user/favorites/restaurant"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId]
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
                            
                            let count = data.objectForKey("favoritesCount") as! Int
                            let like = data.objectForKey("like") as? Bool
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                likeChk = true
                                
                                
                                if(like == true) {
                                    self.mainHeart.setBackgroundImage(UIImage(named: "icon_heart_r")?.alpha(1.0), forState: .Normal)
                                } else {
                                    self.mainHeart.setBackgroundImage(UIImage(named: "icon_heart")?.alpha(0.25), forState: .Normal)
                                }

                                let content: NSString = (count.description)
                                let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 12) / 414)])
                                if(labelSize.width > ((screen.size.width * 24) / 414 )) {
                                    self.mainHeartCount.frame = CGRect(x: (screen.size.width * 43) / 414, y: (screen.size.width * 21) / 414, width: (labelSize.width + 10), height: (screen.size.height * 24) / 736)
                                }
                                
                                self.mainHeartCount.layer.cornerRadius = self.mainHeartCount.frame.size.height/2
                                self.mainHeartCount.text = count.description
                                if(count > 0) {
                                    self.mainHeartCount.hidden = false
                                } else {
                                    self.mainHeartCount.hidden = true
                                }
                                
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
    
    func openFacebook(sender: AnyObject?) {
        let facebookUrl = restaurantView.objectForKey("facebook") as? String
        
        UIApplication.tryURL([facebookUrl!])
    }
    
    func openInstagram(sender : AnyObject?) {
        let instagramUrl = restaurantView.objectForKey("instagram") as? String
        
        UIApplication.tryURL([instagramUrl!])
    }
    
    func restaurantMap(sender: AnyObject) {
        if(restaurantView.objectForKey("longitude") is NSNull) {
            customPop.showInView(self.view, withMessage: "Restaurant location has not been stored .", animated: true)
            return;
        }
        
        
        restaurantMap = storyboard?.instantiateViewControllerWithIdentifier("restaurantMap") as! RestaurantMapController
        
        self.presentViewController(self.restaurantMap, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

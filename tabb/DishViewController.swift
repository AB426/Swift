//
//  DishViewController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 29..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var dishViewBack: UIView!
    
    var isShowIngre: Bool!
    var isShowNutri: Bool!
    var isShowAddOn: Bool!
    
    var nutriView: DishNutritionView!
    var ingreView: DishDetailView!
    var addOnView: DishAddOnView!
    
    var dishHeartCount : UILabel!
    
    var cartPop : PopUpViewController = PopUpViewController(nibName: "PopupView", bundle: nil)
    var optionsPop : DishOptionViewPopUp = DishOptionViewPopUp(nibName: "PopupView", bundle: nil)
    var reviewPop : ReviewPopUp = ReviewPopUp(nibName: "PopupView", bundle: nil)
    
    var search : SearchViewController!
    
    var starList = Array<UIImageView>()
    
    var dishHeart : UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(searchCheck == true) {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        if(notCheck) {
            notCheck = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toppingsList.removeAllObjects()
        optionsList.removeAllObjects()
        excludesList.removeAllObjects()
        
        dishView = self
        
        ingreView = DishDetailView(aView: self.view, title: "Test")
        nutriView = DishNutritionView(aView: self.view, title: "Test")
        addOnView = DishAddOnView(aView: self.view, title: "Test")
        
        self.isShowIngre = false
        self.isShowNutri = false
        self.isShowAddOn = false

        let dishImage = UIImageView()
        dishImage.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.width * 330) / 414)
        dishImage.clipsToBounds = true
        dishImage.contentMode = UIViewContentMode.ScaleAspectFill
        dishImage.layer.cornerRadius = (screen.size.height * 3.5) / 414
        dishViewBack.addSubview(dishImage)
        
        let shadow = UIImageView(image: UIImage(named: "shadow_thumb"))
        shadow.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.height * 330) / 736)
        shadow.clipsToBounds = true
        shadow.layer.cornerRadius = (screen.size.height * 3.5) / 414
        dishViewBack.addSubview(shadow)
        
        
        let loadingView = UIView()
        loadingView.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.width * 11) / 414, width: (screen.size.width * 392) / 414, height: (screen.size.width * 330) / 414)
        loadingView.backgroundColor = UIColor.clearColor()
        dishViewBack.addSubview(loadingView)
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        dispatch_async(dispatch_get_main_queue(), {
            activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
            loadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
        })
        
        if let url = NSURL(string: (foodViewData.objectForKey("picture") as? String)!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    dishImage.image = UIImage(data: imageData)
                    dispatch_async(dispatch_get_main_queue(), {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    })
                }
            }
        }
        
        let like = foodViewData.objectForKey("like") as! Bool
        
        dishHeart = UIButton()
        if(like == true) {
            dishHeart.setBackgroundImage(UIImage(named: "icon_heart_r")?.alpha(1.0), forState: .Normal)
        } else {
            dishHeart.setBackgroundImage(UIImage(named: "icon_heart")?.alpha(0.25), forState: .Normal)
        }
        
        dishHeart.frame = CGRect(x: (screen.size.width * 27) / 414, y: (screen.size.width * 27) / 414, width: (screen.size.width * 29) / 414, height: (screen.size.height * 29) / 736)
        dishHeart.addTarget(self, action: "sendFavoriteFood:", forControlEvents: .TouchUpInside)
        dishViewBack.addSubview(dishHeart)
        dishHeartCount = UILabel()
        dishHeartCount.frame = CGRect(x: (screen.size.width * 43) / 414, y: (screen.size.width * 21) / 414, width: (screen.size.width * 24) / 414, height: (screen.size.height * 24) / 736)
        
        let content: NSString = (foodViewData.objectForKey("favoritesCount")?.description)!
        let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 12) / 414)])
        if(labelSize.width > ((screen.size.width * 24) / 414 )) {
            dishHeartCount.frame = CGRect(x: (screen.size.width * 43) / 414, y: (screen.size.width * 21) / 414, width: (labelSize.width + 10), height: (screen.size.height * 24) / 736)
        }
        
        dishHeartCount.backgroundColor = UIColor.redColor()
        dishHeartCount.layer.cornerRadius = dishHeartCount.frame.size.width/2
        dishHeartCount.clipsToBounds = true
        dishHeartCount.text = foodViewData.objectForKey("favoritesCount")?.description
        dishHeartCount.textColor = UIColor.whiteColor()
        dishHeartCount.font = UIFont(name: roboto, size: (screen.size.width * 12) / 414)
        dishHeartCount.adjustsFontSizeToFitWidth = true
        dishHeartCount.textAlignment = .Center
        dishViewBack.addSubview(dishHeartCount)
        
        if((foodViewData.objectForKey("favoritesCount") as! Int) == 0) {
            dishHeartCount.hidden = true
        }
        
        let review = UIButton()
        review.frame = CGRect(x: (screen.size.width * 358) / 414, y: (screen.size.width * 27) / 414, width: (screen.size.width * 29) / 414, height: (screen.size.height * 29) / 736)
        
        review.addTarget(self, action: "getReviewList:", forControlEvents: .TouchUpInside)
        dishViewBack.addSubview(review)
        
        let value = foodViewData.objectForKey("reviewCount") as? Int
        if(value > 0) {
            review.setBackgroundImage(UIImage(named: "icon_review"), forState: .Normal)
        } else {
            review.setBackgroundImage(UIImage(named: "icon_review")?.alpha(0.25), forState: .Normal)
        }
        
        let reviewCount = UILabel()
        reviewCount.frame = CGRect(x: (screen.size.width * 374) / 414, y: (screen.size.width * 21) / 414, width: (screen.size.width * 24) / 414, height: (screen.size.height * 24) / 736)
        
        let content1: NSString = (foodViewData.objectForKey("favoritesCount")?.description)!
        let labelSize1 = content1.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 12) / 414)])
        if(labelSize1.width > ((screen.size.width * 24) / 414 )) {
            reviewCount.frame = CGRect(x: (screen.size.width * 374) / 414, y: (screen.size.width * 21) / 414, width: (labelSize1.width + 10), height: (screen.size.height * 24) / 736)
        }
        
        reviewCount.backgroundColor = UIColor.redColor()
        reviewCount.layer.cornerRadius = reviewCount.frame.size.width/2
        reviewCount.clipsToBounds = true
        reviewCount.text = foodViewData.objectForKey("reviewCount")?.description
        reviewCount.textColor = UIColor.whiteColor()
        reviewCount.font = UIFont(name: roboto, size: (screen.size.width * 12) / 414)
        reviewCount.adjustsFontSizeToFitWidth = true
        reviewCount.textAlignment = .Center
        dishViewBack.addSubview(reviewCount)
        
        if((foodViewData.objectForKey("reviewCount") as! Int) == 0) {
            reviewCount.hidden = true
        }
        
        let dishName = UILabel()
        dishName.frame = CGRect(x: (screen.size.width * 27) / 414, y: (screen.size.height * 290) / 736, width: (screen.size.width * 225) / 414, height: (screen.size.height * 30) / 736)
        dishName.text = foodViewData.objectForKey("name") as? String
        dishName.font = UIFont(name: roboto, size: (screen.size.width * 22) / 414)
        dishName.backgroundColor = UIColor.clearColor()
        dishName.numberOfLines = 2
        //mainName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        dishName.sizeToFit()
        //size 재조정
        dishName.frame.origin.y = ((screen.size.height * 318) / 736 - dishName.frame.size.height)
        dishName.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        dishViewBack.addSubview(dishName)
        
        let dishPrice = UILabel()
        dishPrice.frame = CGRect(x: (screen.size.width * 259) / 414, y: (screen.size.height * 290) / 736, width: (screen.size.width * 80) / 414, height: (screen.size.height * 30) / 736)
        dishPrice.text = ((foodViewData.objectForKey("price") as! Double).format(someDoubleFormat)) + "KD"
        dishPrice.font = UIFont(name: roboto, size: (screen.size.width * 22) / 414)
        dishPrice.backgroundColor = UIColor.clearColor()
        dishPrice.adjustsFontSizeToFitWidth = true
        dishPrice.textAlignment = .Right
        dishPrice.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        dishViewBack.addSubview(dishPrice)
        
        
        let grade_x = (screen.size.width * 27) / 414
        let gradeWidth = (screen.size.width * 17) / 414
        var count:CGFloat = 0
        for(var index = 0; index < 5; ++index) {
            let star = UIImageView(image: UIImage(named: "icon_star_off"))
            star.frame = CGRect(x: grade_x + (count * gradeWidth), y: (dishName.frame.origin.y - (screen.size.height * 20) / 736), width: (screen.size.width * 17) / 414, height: (screen.size.height * 17) / 736)
            dishViewBack.addSubview(star)
            
            starList.append(star)
            
            count++
        }
        
        //grade
        let grade = foodViewData.objectForKey("grade") as! Double
        
        gradeVisible(starList, grade: grade)
        
        let dishAdd = UIButton()
        dishAdd.frame =  CGRect(x: (screen.size.width * 350) / 414, y: (screen.size.height * 278) / 736, width: (screen.size.width * 37) / 414, height: (screen.size.width * 37) / 414)
        dishAdd.setBackgroundImage(UIImage(named: "icon_add"), forState: .Normal)
        dishAdd.addTarget(self, action: "addCart:", forControlEvents: UIControlEvents.TouchUpInside)
        dishViewBack.addSubview(dishAdd)
        
        let ingreBtn = UIButton()
        ingreBtn.frame = CGRect(x: (screen.size.width * 0) / 414, y: (screen.size.height * 352) / 736, width: (screen.size.width * 143) / 414, height: (screen.size.height * 138) / 736)
        ingreBtn.setBackgroundImage(UIImage(named: "option_1"), forState: UIControlState.Normal)
        ingreBtn.setBackgroundImage(UIImage(named: "option_1r"), forState: UIControlState.Highlighted)
        ingreBtn.backgroundColor = UIColor.clearColor()
        ingreBtn.setTitle("INGREDIENTS", forState: UIControlState.Normal)
        ingreBtn.titleLabel?.font = UIFont(name: robotoBold, size: (screen.size.width * 15) / 414)
        ingreBtn.setTitleColor(UIColorFromHex(0xffffff, alpha: 1.0), forState: UIControlState.Normal)
        ingreBtn.addTarget(self, action: "viewDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        ingreBtn.tag = 1
        dishViewBack.addSubview(ingreBtn)
        
        let nutriBtn = UIButton()
        nutriBtn.frame = CGRect(x: (screen.size.width * 143) / 414, y: (screen.size.height * 352) / 736, width: (screen.size.width * 138) / 414, height: (screen.size.height * 138) / 736)
        nutriBtn.setBackgroundImage(UIImage(named: "option_2"), forState: UIControlState.Normal)
        nutriBtn.setBackgroundImage(UIImage(named: "option_2r"), forState: UIControlState.Highlighted)
        nutriBtn.backgroundColor = UIColor.clearColor()
        nutriBtn.setTitle("NUTRITION", forState: UIControlState.Normal)
        nutriBtn.titleLabel?.font = UIFont(name: robotoBold, size: (screen.size.width * 15) / 414)
        nutriBtn.setTitleColor(UIColorFromHex(0xffffff, alpha: 1.0), forState: UIControlState.Normal)
        nutriBtn.addTarget(self, action: "viewDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        nutriBtn.tag = 2
        dishViewBack.addSubview(nutriBtn)
        
        let addOnBtn = UIButton()
        addOnBtn.frame = CGRect(x: (screen.size.width * 281) / 414, y: (screen.size.height * 352) / 736, width: (screen.size.width * 143) / 414, height: (screen.size.height * 138) / 736)
        addOnBtn.setBackgroundImage(UIImage(named: "option_3"), forState: UIControlState.Normal)
        addOnBtn.setBackgroundImage(UIImage(named: "option_3r"), forState: UIControlState.Highlighted)
        addOnBtn.backgroundColor = UIColor.clearColor()
        addOnBtn.setTitle("ADD-ONS", forState: UIControlState.Normal)
        addOnBtn.titleLabel?.font = UIFont(name: robotoBold, size: (screen.size.width * 15) / 414)
        addOnBtn.setTitleColor(UIColorFromHex(0xffffff, alpha: 1.0), forState: UIControlState.Normal)
        addOnBtn.addTarget(self, action: "viewDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        addOnBtn.tag = 3
        dishViewBack.addSubview(addOnBtn)
        
        let dishContent = UILabel()
        dishContent.frame = CGRect(x: (screen.size.width * 27) / 414, y: (screen.size.height * 490) / 736, width: (screen.size.width * 280) / 414, height: (screen.size.height * 129) / 736)
        dishContent.backgroundColor = UIColor.clearColor()
        dishContent.numberOfLines = 0
        dishContent.text = foodViewData.objectForKey("description") as? String
        dishContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        dishContent.textColor = UIColorFromHex(0xaaaaaa, alpha: 1.0)
        dishViewBack.addSubview(dishContent)
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        dishViewBack.addSubview(callView)
        
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
        
    }

    func addCart(sender: AnyObject?) {
        
//        if(checkinId == 0) {
//            return;
//        }
        
        let options = foodViewData.objectForKey("options") as! NSArray
        if(options.count > 0) {
            //옵션이 존재한다면!!!
            foodViewGoCart = true
            optionsList.removeAllObjects()
            optionsPop = DishOptionViewPopUp(nibName: "PopupView", bundle: nil)
            optionsPop.showInView(self.view, withMessage: "Food Options", animated: true, items: options)
        } else {
            self.goCart()
        }
    }
    
    func goCart() {

        let url: String = serverURL + "user/cartItem/add"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId": checkinId, "foodId":foodId, "quantity" : 1, "toppings" : toppingsList, "options" : optionsList, "excludes" : excludesList]
        
        print("cart add \(newPost)")
        
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
                            
                            
                            let data = post["data"] as! NSDictionary
                            cartId = data.objectForKey("cartId") as! Double
                            pref.setValue(cartId, forKey: "cartId")
                            dispatch_async(dispatch_get_main_queue(), {
                                dishViewBackFlag = true
                                self.cartPop.showInView(self.view, withMessage: "cartPop", animated: true)
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
    
    func viewDetail(sender: AnyObject?) {

        switch sender!.tag {
        case 1:
            if(self.isShowIngre == true) {
                ingreView.removeFromSuperview()
                ingreView.hideView(sender! as! UIButton)
                self.isShowIngre = false
            }
            if(self.isShowNutri == true) {
                nutriView.removeFromSuperview()
                nutriView.hideView(sender! as! UIButton)
                self.isShowNutri = false
            }
            if(self.isShowAddOn == true) {
                addOnView.removeFromSuperview()
                addOnView.hideView(sender! as! UIButton)
                self.isShowAddOn = false
            }
            self.isShowIngre = true
            
            dishViewBack.addSubview(ingreView)
            ingreView.showView()
            
        case 2:
            if(self.isShowIngre == true) {
                ingreView.removeFromSuperview()
                ingreView.hideView(sender! as! UIButton)
                self.isShowIngre = false
            }
            if(self.isShowNutri == true) {
                nutriView.removeFromSuperview()
                nutriView.hideView(sender! as! UIButton)
                self.isShowNutri = false
            }
            if(self.isShowAddOn == true) {
                addOnView.removeFromSuperview()
                addOnView.hideView(sender! as! UIButton)
                self.isShowAddOn = false
            }
            self.isShowNutri = true
            
            dishViewBack.addSubview(nutriView)
            nutriView.showView()
        case 3:
            if(self.isShowIngre == true) {
                ingreView.removeFromSuperview()
                ingreView.hideView(sender! as! UIButton)
                self.isShowIngre = false
            }
            if(self.isShowNutri == true) {
                nutriView.removeFromSuperview()
                nutriView.hideView(sender! as! UIButton)
                self.isShowNutri = false
            }
            if(self.isShowAddOn == true) {
                addOnView.removeFromSuperview()
                addOnView.hideView(sender! as! UIButton)
                self.isShowAddOn = false
            }
            dishViewBack.addSubview(addOnView)
            self.isShowAddOn = true
            addOnView.showView()
        default :
            print("Default")
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
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
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
    
    func sendFavoriteFood(sender: AnyObject?) {
        let url: String = serverURL + "user/favorites/food"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "foodId": foodId]
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
                            let like = data.objectForKey("like") as! Bool
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                if(like == true) {
                                    self.dishHeart.setBackgroundImage(UIImage(named: "icon_heart_r")?.alpha(1.0), forState: .Normal)
                                } else {
                                    self.dishHeart.setBackgroundImage(UIImage(named: "icon_heart")?.alpha(0.25), forState: .Normal)
                                }
                                
                                let content: NSString = (count.description)
                                let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 12) / 414)])
                                if(labelSize.width > ((screen.size.width * 24) / 414 )) {
                                    self.dishHeartCount.frame = CGRect(x: (screen.size.width * 43) / 414, y: (screen.size.width * 21) / 414, width: (labelSize.width + 10), height: (screen.size.height * 24) / 736)
                                }
                                
                                self.dishHeartCount.layer.cornerRadius = self.dishHeartCount.frame.size.height/2
                                self.dishHeartCount.text = count.description
                                if(count > 0) {
                                    self.dishHeartCount.hidden = false
                                } else {
                                    self.dishHeartCount.hidden = true
                                }
                                
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
    
    func backToBrowseMenu() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
    
    func getReviewList(sender : AnyObject?) {
        let url: String = serverURL + "user/food/comments"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "foodId": foodId, "lastId" : 0, "size" : 100000]
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
                            reviewList = data.objectForKey("items") as! NSArray
                            
                            if(reviewList.count == 0) {
                                dispatch_async(dispatch_get_main_queue(), {
                                    customPop.showInView(self.view, withMessage: "No review posted yet.", animated: true)
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    // code here
                                    self.reviewPop = ReviewPopUp(nibName: "PopupView", bundle: nil)
                                    self.reviewPop.showInView(self.view, withMessage: "Review", animated: true)
                                    
                                })
                            }
                            
                            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

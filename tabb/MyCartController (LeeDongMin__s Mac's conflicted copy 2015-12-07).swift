//
//  MyCartController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 21..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class MyCartController: UIViewController {
    
    @IBOutlet weak var cartBack: UIView!
    
    var totalPrice: UILabel!
    var makeOrder: UIButton!
    var profileImage : UIImageView!
    var profileScroll : UIScrollView!
    var cartItemScroll : UIClickScrollView!
    
    //cartItem
    var cartItemView : UIView!
    var cartImage : UIImageView!
    var cartTitle : UILabel!
    var cartOption: UILabel!
    var cartPrice: UILabel!
    var cartDel: UIButton!
    var cartAdd: UIButton!
    var cartAmount: UILabel!
    
    var profileName : UILabel!
    
    var search : SearchViewController!
    
    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCheckInmemberList()
        self.getCartList()
        
        cartItemScroll = UIClickScrollView()
        cartItemScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 138) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 485) / 736)
        cartItemScroll.delaysContentTouches = false
        cartItemScroll.showsVerticalScrollIndicator = false
        self.view.addSubview(cartItemScroll)
        
        profileScroll = UIScrollView()
        profileScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 32) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
        profileScroll.backgroundColor = UIColor.clearColor()
        
        
        profileName = UILabel()
        profileName.frame = CGRect(x: (screen.size.width * 127) / 414, y: (screen.size.height * 98) / 736, width: (screen.size.width * 160) / 414, height: (screen.size.height * 15) / 736)
        profileName.textColor = UIColor.whiteColor()
        profileName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        profileName.adjustsFontSizeToFitWidth = true
        profileName.textAlignment = .Center
        cartBack.addSubview(profileName)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func updateDisplay() {
        var count : CGFloat = 0
        var totalPrice : Double = 0
        for(var index = 0 ; index < cartItems.count; index++) {
            cartItemView = UIView()
            cartItemView.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count, width: (screen.size.width * 392) / 414, height: (screen.size.height * 77) / 736)
            cartItemView.backgroundColor = UIColor.whiteColor()
            cartItemView.layer.borderWidth = 1
            cartItemView.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
            cartItemScroll.addSubview(cartItemView)
            
            cartImage = UIImageView()
            cartImage.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            cartItemView.addSubview(cartImage)
            let loadingView = UIView()
            loadingView.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            loadingView.backgroundColor = UIColor.clearColor()
            cartItemView.addSubview(loadingView)
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 22) / 414, (screen.size.height * 22) / 736);
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
                        self.cartImage.image = UIImage(data: imageData)
                        dispatch_async(dispatch_get_main_queue(), {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        })
                    }
                }
            }
            
            
            
            cartTitle = UILabel()
            cartTitle.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 8) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            cartTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            cartTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
            cartTitle.backgroundColor = UIColor.clearColor()
            cartTitle.text = cartItems[index].objectForKey("foodName") as? String
            cartItemView.addSubview(cartTitle)
            
            cartOption = UILabel()
            cartOption.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 28) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            cartOption.textColor = UIColorFromHex(0x888888, alpha: 1.0)
            cartOption.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            cartOption.backgroundColor = UIColor.clearColor()
            cartItemView.addSubview(cartOption)

            cartPrice = UILabel()
            cartPrice.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 28) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            cartPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            cartPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            cartPrice.backgroundColor = UIColor.clearColor()
            cartPrice.text = cartItems[index].objectForKey("amount") as? String
            cartItemView.addSubview(cartPrice)
            
            cartAmount = UILabel()
            cartAmount.frame = CGRect(x: (screen.size.width * 323) / 414, y: (screen.size.height * 21) / 736, width: (screen.size.width * 34) / 414, height: (screen.size.height * 34) / 736)
            cartAmount.textColor = UIColorFromHex(0x3a3a3a, alpha: 1.0)
            cartAmount.font = UIFont(name: lato, size: (screen.size.width * 22) / 414)
            cartAmount.backgroundColor = UIColor.clearColor()
            cartItemView.addSubview(cartAmount)
            
            cartDel = UIButton()
            cartDel.frame = CGRect(x: (screen.size.width * 300) / 414, y: (screen.size.height * 27) / 736, width: (screen.size.width * 23) / 414, height: (screen.size.height * 23) / 736)
            cartDel.backgroundColor = UIColor.clearColor()
            cartDel.setBackgroundImage(UIImage(named: "icon_minus"), forState: UIControlState.Normal)
            cartItemView.addSubview(cartDel)
            
            cartAdd = UIButton()
            cartAdd.frame = CGRect(x: (screen.size.width * 357) / 414, y: (screen.size.height * 27) / 736, width: (screen.size.width * 23) / 414, height: (screen.size.height * 23) / 736)
            cartAdd.backgroundColor = UIColor.clearColor()
            cartAdd.setBackgroundImage(UIImage(named: "icon_plus"), forState: UIControlState.Normal)
            cartItemView.addSubview(cartAdd)
            
            count++;
        }
        
        
        totalPrice = UILabel()
        totalPrice.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
        totalPrice.layer.borderWidth = 1
        totalPrice.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
        totalPrice.textAlignment = .Center
        totalPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalPrice.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
        totalPrice.backgroundColor = UIColor.whiteColor()
        totalPrice.text = "TOTAL 36.00 KD"
        cartItemScroll.addSubview(totalPrice)
        
        //Button Effect
        makeOrder = UIButton()
        makeOrder.frame = CGRect(x: 0, y: (((screen.size.height * 77) / 736) * count) + totalPrice.frame.size.height, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
        makeOrder.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 1.0)), forState: UIControlState.Normal)
        makeOrder.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.6)), forState: UIControlState.Highlighted)
        makeOrder.roundCorners(([.BottomRight, .BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        makeOrder.clipsToBounds = true
        makeOrder.setTitle("MAKE ORDER", forState: .Normal)
        makeOrder.titleLabel?.textColor = UIColor.whiteColor()
        makeOrder.titleLabel?.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
        cartItemScroll.addSubview(makeOrder)
        
        //스크롤 사이즈
        cartItemScroll.contentSize = CGSize(width: (screen.size.width * 392) / 414, height: (((screen.size.height * 77) / 736) * count) + totalPrice.frame.size.height + makeOrder.frame.size.height)
        

    }
    
    func updateProfileScroll() {
        //scrolling pageview
        
        let profileWidth = (screen.size.width * 58) / 414
        let profileHeight = (screen.size.height * 58) / 736
        var profile_x_count : CGFloat = 0
        
        let profileTotalView = UIView()
        profileTotalView.backgroundColor = UIColor.clearColor()
        profileTotalView.frame.origin = CGPointMake(0,0)
        
        let padding = CGSizeMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736)
        profileTotalView.frame.size.width = ((profileWidth + padding.width) * CGFloat(members.count)) - padding.width
        profileTotalView.frame.size.height = (profileHeight +  2.0 * padding.height)
        
        let scrollWidth = (screen.size.width * 392) / 414
        if(members.count <= 5) {
            profileTotalView.frame.origin = CGPointMake((scrollWidth - profileTotalView.frame.size.width) / 2, 0)
        }
        
        for(var index = 0; index < members.count; ++index) {
            let profileView = UIView()
            profileView.frame = CGRect(x: (profile_x_count * profileWidth) + ((screen.size.width * 11) / 414 * profile_x_count), y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
            
            let profileImg = UIImageView()
            profileImg.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
            profileView.addSubview(profileImg)
            
            let loadingView = UIView()
            loadingView.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
            loadingView.backgroundColor = UIColor.clearColor()
            profileView.addSubview(loadingView)
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 22) / 414, (screen.size.height * 22) / 736);
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                loadingView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
            })
            if let url = NSURL(string: (members[0].objectForKey("picture") as? String)!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        profileImg.image = UIImage(data: imageData)
                        dispatch_async(dispatch_get_main_queue(), {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        })
                    }
                }
            }
            
            profileImg.layer.cornerRadius = profileImg.frame.size.height / 2
            profileImg.clipsToBounds = true
            
            loadingView.layer.cornerRadius = loadingView.frame.size.height / 2
            loadingView.clipsToBounds = true
            
            let profileBtn = UIButton()
            profileBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
//            profileBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: UIControlState.Normal)
//            profileBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: UIControlState.Highlighted)
            profileBtn.layer.cornerRadius = loadingView.frame.size.height / 2
            profileBtn.clipsToBounds = true
            profileBtn.addTarget(self, action: "getOtherCartList:", forControlEvents: UIControlEvents.TouchUpInside)
            profileBtn.tag = index
            profileView.addSubview(profileBtn)
            
            profileTotalView.addSubview(profileView)
            
            ++profile_x_count
        }
        
        
        profileScroll.addSubview(profileTotalView)
        profileScroll.contentSize = profileTotalView.frame.size
        profileScroll.showsHorizontalScrollIndicator = false
        profileScroll.indicatorStyle = .Default
        
        profileName.text = (members[0].objectForKey("userName") as? String)!
        
        self.view.addSubview(profileScroll)
    }
    
    func getCartList() {
        let url: String = serverURL + "user/cartItem/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "userId": 43, "lastId":0, "size": 30]
        
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
                            
                            let chk: AnyObject? = data.valueForKey("members")
                            
                            if(chk?.count == 0) {
                                
                            } else {
                                cartItems = data.valueForKey("items") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateDisplay()
                                })
                            }
                            
                        } else {
                            let errorMsg: String! = post["errorMsg"] as! String
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
    
    func getCheckInmemberList() {
        let url: String = serverURL + "user/checkin/members"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId": checkinId]
        
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
                        //print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            
                            let data = post["data"] as! NSDictionary
                            
                            let chk: AnyObject? = data.valueForKey("members")
                            
                            if(chk?.count == 0) {
                                
                            } else {
                                members = data.valueForKey("members") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateProfileScroll()
                                })
                            }
                            
                        } else {
                            let errorMsg: String! = post["errorMsg"] as! String
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
    
    func getOtherCartList(sender: AnyObject) {
        profileName.text = members[sender.tag].objectForKey("userName") as? String
    }
    
    func changeCartItem() {
        //카트 아이템 수량 변경
        let url: String = serverURL + "user/cartItem/quantity"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "cartItemId": "", "quantity" : ""]
        
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
                            
                        } else {
                            let errorMsg: String! = post["errorMsg"] as! String
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
    
    func makeCartOrder() {
        //카트아이템 주문
        let url: String = serverURL + "user/cart/order"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "cartId": cartId, "checkinId" : checkinId]
        
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
                            
                        } else {
                            let errorMsg: String! = post["errorMsg"] as! String
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

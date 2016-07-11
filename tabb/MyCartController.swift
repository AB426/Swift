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
    var profileScroll : UIScrollView!
    var cartItemScroll : UIClickScrollView!
    
    //cartItem
    var cartItemView : UIView!
    var cartTitle : UILabel!
    var cartOption: UILabel!
    var cartPrice: UILabel!
    var cartDel: UIButton!
    var cartAdd: UIButton!
    
    var profileName : UILabel!
    
    var search : SearchViewController!
    
    var cartList : Array<UIImageView> = []
    var profileList : Array<UIImageView> = []
    var amountList : Array<UILabel> = []
    
    
    var callView = UIView()
    
    var tempUserId : Double!
    var tempUserChk = false
    
    var cartOptionPop : MyCartOptionPopUp = MyCartOptionPopUp(nibName: "PopupView", bundle: nil)
    
    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        myCart = self

        cartItemScroll = UIClickScrollView()
        cartItemScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 138) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 485) / 736)
        cartItemScroll.delaysContentTouches = false
        cartItemScroll.showsVerticalScrollIndicator = false
        cartBack.addSubview(cartItemScroll)
        
        profileScroll = UIScrollView()
        profileScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 32) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 92) / 736)
        profileScroll.backgroundColor = UIColor.clearColor()
        
        
        profileName = UILabel()
        profileName.frame = CGRect(x: (screen.size.width * 127) / 414, y: (screen.size.height * 98) / 736, width: (screen.size.width * 160) / 414, height: (screen.size.height * 15) / 736)
        profileName.textColor = UIColor.whiteColor()
        profileName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        profileName.adjustsFontSizeToFitWidth = true
        profileName.textAlignment = .Center
        cartBack.addSubview(profileName)
        
        callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        cartBack.addSubview(callView)
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let subViews = cartItemScroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

//        if(checkinId > 0) {
//            amountList = []
//            profileList = []
//            
//            self.getCheckInmemberList()
//        } else {
//            let tabbLogo = UIImageView(image: UIImage(named: "logo"))
//            tabbLogo.frame = CGRect(x: (screen.size.width * 153) / 414, y: 0 , width: (screen.size.width * 85) / 414, height: (screen.size.height * 85) / 736)
//            cartItemScroll.addSubview(tabbLogo)
//            
//            let tabbNotCartContent = UITextView()
//            tabbNotCartContent.frame = CGRect(x: (screen.size.width * 76) / 414, y: (screen.size.height * 105) / 736 , width: (screen.size.width * 240) / 414, height: (screen.size.height * 85) / 736)
//            tabbNotCartContent.text = "You haven't selected any food yet"
//            tabbNotCartContent.backgroundColor = UIColor.clearColor()
//            tabbNotCartContent.editable = false
//            tabbNotCartContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
//            tabbNotCartContent.textColor = UIColorFromHex(0x999999, alpha: 1.0)
//            tabbNotCartContent.textAlignment = .Center
//            cartItemScroll.addSubview(tabbNotCartContent)
//        }
        
        amountList = []
        profileList = []
        
        self.getCheckInmemberList()

    }
    
    func updateDisplay() {
        amountList.removeAll()
        let subViews = cartItemScroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
//        cartItemScroll = UIClickScrollView()
//        cartItemScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 138) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 485) / 736)
//        cartItemScroll.delaysContentTouches = false
//        cartItemScroll.showsVerticalScrollIndicator = false
//        cartBack.addSubview(cartItemScroll)
        
//        callView.removeFromSuperview()
//        
//        callView = UIView()
//        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
//        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
//        callView.layer.cornerRadius = callView.frame.size.width / 2
//        cartBack.addSubview(callView)
//        
//        let callImage = UIImageView(image: UIImage(named: "icon_call"))
//        callImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
//        callView.addSubview(callImage)
//        
//        let callBtn = UIButton()
//        callBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
//        callBtn.backgroundColor = UIColor.clearColor()
//        callBtn.layer.cornerRadius = callBtn.frame.size.width / 2
//        callBtn.clipsToBounds = true
//        callBtn.addTarget(self, action: "callAction:", forControlEvents: .TouchUpInside)
//        callBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
//        callBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
//        callView.addSubview(callBtn)
        
        if(cartItems.count <= 0) {
            print("cartitems 0")
            let tabbLogo = UIImageView(image: UIImage(named: "logo"))
            tabbLogo.frame = CGRect(x: (screen.size.width * 153) / 414, y: 0 , width: (screen.size.width * 85) / 414, height: (screen.size.height * 85) / 736)
            cartItemScroll.addSubview(tabbLogo)
            
            let tabbNotCartContent = UITextView()
            tabbNotCartContent.frame = CGRect(x: (screen.size.width * 76) / 414, y: (screen.size.height * 105) / 736 , width: (screen.size.width * 240) / 414, height: (screen.size.height * 85) / 736)
            tabbNotCartContent.text = "The Cart is empty."
            tabbNotCartContent.backgroundColor = UIColor.clearColor()
            tabbNotCartContent.editable = false
            tabbNotCartContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            tabbNotCartContent.textColor = UIColorFromHex(0x999999, alpha: 1.0)
            tabbNotCartContent.textAlignment = .Center
            cartItemScroll.addSubview(tabbNotCartContent)
            
            return;
        }
        
        cartList.removeAll()
        var cartImageCount = 0
        var count : CGFloat = 0
        var total : Double = 0
        for(var index = 0 ; index < cartItems.count; index++) {
            cartItemView = UIView()
            cartItemView.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count, width: (screen.size.width * 392) / 414, height: (screen.size.height * 77) / 736)
            cartItemView.backgroundColor = UIColor.whiteColor()
            cartItemView.layer.borderWidth = 0.5
            cartItemView.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
            cartItemScroll.addSubview(cartItemView)
            
            let cartImage = UIImageView()
            cartImage.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            cartItemView.addSubview(cartImage)
            
            cartList.append(cartImage)

            if(cartImageList.count == cartItems.count) {
                cartImage.image = cartImageList[index] as? UIImage
                
            } else {
                cartImageList.removeAllObjects()
                
                let loadingView = UIView()
                loadingView.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
                loadingView.backgroundColor = UIColor.clearColor()
                cartItemView.addSubview(loadingView)
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
                dispatch_async(dispatch_get_main_queue(), {
                    activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 22) / 414, (screen.size.height * 22) / 736);
                    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                    loadingView.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    
                })
                if let url = NSURL(string: (cartItems[index].objectForKey("picture") as? String)!) {
                    let request = NSURLRequest(URL: url)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                        if let imageData = data as NSData? {
                            
                            ++cartImageCount
                            
                            cartImage.image = UIImage(data: imageData)
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if(cartImageCount == cartItems.count) {
                                    
                                    //gray image add list
                                    for(var x=0; x<cartImageCount; ++x) {
                                        
                                        cartImageList.addObject(self.cartList[x].image!)
                                    }
                                    
                                }
                                
                                activityIndicator.stopAnimating()
                                activityIndicator.removeFromSuperview()
                            })
                        }
                    }
                }
            }
            
            let cartOptionViewBtn = UIButton()
            cartOptionViewBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            cartOptionViewBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: UIControlState.Normal)
            cartOptionViewBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.5)), forState: UIControlState.Highlighted)
            cartOptionViewBtn.addTarget(self, action: "callFoodOptionView:", forControlEvents: UIControlEvents.TouchUpInside)
            cartOptionViewBtn.tag = index
            cartItemView.addSubview(cartOptionViewBtn)

            
            cartTitle = UILabel()
            cartTitle.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 8) / 736, width: (screen.size.width * 200) / 414, height: (screen.size.height * 20) / 736)
            cartTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            cartTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
            cartTitle.backgroundColor = UIColor.clearColor()
            cartTitle.text = cartItems[index].objectForKey("foodName") as? String
            cartTitle.numberOfLines = 1
            cartItemView.addSubview(cartTitle)
            
            cartOption = UILabel()
            cartOption.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 28) / 736, width: (screen.size.width * 200) / 414, height: (screen.size.height * 20) / 736)
            cartOption.textColor = UIColorFromHex(0x888888, alpha: 1.0)
            cartOption.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            cartOption.backgroundColor = UIColor.clearColor()
            
            let option = cartItems[index].objectForKey("description") as? String
            if(option == "") {
                cartOption.text = "No options"
            } else {
                cartOption.text = option
            }
            cartItemView.addSubview(cartOption)

            cartPrice = UILabel()
            cartPrice.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 48) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            cartPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            cartPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            cartPrice.backgroundColor = UIColor.clearColor()
            cartPrice.text = (cartItems[index].objectForKey("unitPrice") as! Double).format(someDoubleFormat) + " KD"
            cartItemView.addSubview(cartPrice)
            
            let unitPrice = (cartItems[index].objectForKey("unitPrice") as? Double)!
            let quantity = (cartItems[index].objectForKey("quantity") as? Int)!
            
            total = total + (Double.init(quantity) * unitPrice)
            
            let cartAmount = UILabel()
            cartAmount.frame = CGRect(x: (screen.size.width * 323) / 414, y: (screen.size.height * 21) / 736, width: (screen.size.width * 34) / 414, height: (screen.size.height * 34) / 736)
            cartAmount.textColor = UIColorFromHex(0x3a3a3a, alpha: 1.0)
            cartAmount.font = UIFont(name: lato, size: (screen.size.width * 22) / 414)
            cartAmount.backgroundColor = UIColor.clearColor()
            cartAmount.textAlignment = .Center
            cartAmount.text = cartItems[index].objectForKey("quantity")?.description
            cartItemView.addSubview(cartAmount)
            
            amountList.append(cartAmount)
            
            cartDel = UIButton()
            cartDel.frame = CGRect(x: (screen.size.width * 300) / 414, y: (screen.size.height * 27) / 736, width: (screen.size.width * 23) / 414, height: (screen.size.height * 23) / 736)
            cartDel.backgroundColor = UIColor.clearColor()
            if(cartItems[index].objectForKey("quantity") as! Int > 1) {
                cartDel.setBackgroundImage(UIImage(named: "icon_minus"), forState: UIControlState.Normal)
            } else {
                cartDel.setBackgroundImage(UIImage(named: "icon_del"), forState: UIControlState.Normal)
            }
            
            if(tempUserChk == false) {
            cartDel.tag = -(index + 1)
            cartDel.addTarget(self, action: "changeCartItem:", forControlEvents: .TouchUpInside)
            cartItemView.addSubview(cartDel)
            
            cartAdd = UIButton()
            cartAdd.frame = CGRect(x: (screen.size.width * 357) / 414, y: (screen.size.height * 27) / 736, width: (screen.size.width * 23) / 414, height: (screen.size.height * 23) / 736)
            cartAdd.backgroundColor = UIColor.clearColor()
            cartAdd.setBackgroundImage(UIImage(named: "icon_plus"), forState: UIControlState.Normal)
            cartAdd.tag = (index + 1)
            cartAdd.addTarget(self, action: "changeCartItem:", forControlEvents: .TouchUpInside)
            cartItemView.addSubview(cartAdd)
            }
            
            count++;
        }
        
        
        
        if(cartItems.count > 0) {
        
            totalPrice = UILabel()
            totalPrice.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
            totalPrice.layer.borderWidth = 1
            totalPrice.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
            totalPrice.textAlignment = .Center
            totalPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            totalPrice.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
            totalPrice.backgroundColor = UIColor.whiteColor()
            totalPrice.text = "TOTAL " + total.format(someDoubleFormat) + " KD"
            cartItemScroll.addSubview(totalPrice)
            
            //Button Effect
            makeOrder = UIButton()
            makeOrder.frame = CGRect(x: 0, y: (((screen.size.height * 77) / 736) * count) + totalPrice.frame.size.height, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
            makeOrder.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 1.0)), forState: UIControlState.Normal)
            makeOrder.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.6)), forState: UIControlState.Highlighted)
            makeOrder.roundCorners(([.BottomRight, .BottomLeft]), radius: (screen.size.width * 3.5) / 414)
            makeOrder.clipsToBounds = true
            makeOrder.setTitle("ORDER", forState: .Normal)
            makeOrder.titleLabel?.textColor = UIColor.whiteColor()
            makeOrder.titleLabel?.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
            makeOrder.addTarget(self, action: "makeCartOrder:", forControlEvents: .TouchUpInside)
            
            if(tempUserId == members[0].objectForKey("userId") as! Double) {
                cartItemScroll.addSubview(makeOrder)
            }
        }
        
        //스크롤 사이즈
        cartItemScroll.contentSize = CGSize(width: (screen.size.width * 392) / 414, height: (((screen.size.height * 77) / 736) * count) + totalPrice.frame.size.height + makeOrder.frame.size.height)

    }
    
    func updateProfileScroll() {
        //scrolling pageview
        
//        if(members.count > 0) {
//            
//        } else {
//            profileList.removeAll()
//            imageList.removeAllObjects()
//            grayImageList.removeAllObjects()
//        }
        
        profileList.removeAll()
        

        profileScroll.removeFromSuperview()
        profileScroll = UIScrollView()
        profileScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 32) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 92) / 736)
        profileScroll.backgroundColor = UIColor.clearColor()
        
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
        
        var imageDownCount = 0
        
        for(var index = 0; index < members.count; ++index) {
            let profileView = UIView()
            profileView.frame = CGRect(x: (profile_x_count * profileWidth) + ((screen.size.width * 11) / 414 * profile_x_count), y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
            
            let profileImg = UIImageView()
            profileImg.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
            profileView.addSubview(profileImg)
            
            profileList.append(profileImg)
            
            if(imageList.count == members.count) {
                
                if(index == 0) {
                    profileImg.image = imageList[index] as? UIImage
                } else {
                    profileImg.image = grayImageList[index] as? UIImage
                }
                
            } else {
                imageList.removeAllObjects()
                grayImageList.removeAllObjects()
                
                let loadingView = UIView()
                loadingView.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
                loadingView.backgroundColor = UIColor.clearColor()
                profileView.addSubview(loadingView)
                
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
                dispatch_async(dispatch_get_main_queue(), {
                    activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 12) / 414, (screen.size.height * 12) / 736);
                    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
                    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                    loadingView.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    
                })
                if let url = NSURL(string: (members[index].objectForKey("picture") as? String)!) {
                    let request = NSURLRequest(URL: url)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                        if let imageData = data as NSData? {
                            
                            let image = UIImage(data: imageData)
                            
                            ++imageDownCount
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                profileImg.image = image
                                
                                if(imageDownCount == members.count) {
                                    
                                    //gray image add list
                                    for(var x=0; x<imageDownCount; ++x) {
                                        
                                        imageList.addObject(self.profileList[x].image!)
                                        grayImageList.addObject(UIImage.convertToGrayScale(self.profileList[x].image!))
                                    }
                                    
                                    for(var y=0; y<imageDownCount; ++y) {
                                        if(y != 0) {
                                            self.profileList[y].image = grayImageList[y] as? UIImage
                                        }
                                    }
                                    
                                }
                                
                                activityIndicator.stopAnimating()
                                activityIndicator.removeFromSuperview()
                            })
                        }
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
    
    func getCartList(userId : Double) {
        let url: String = serverURL + "user/cartItem/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "userId": userId, "lastId":0, "size": 30]
        
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
                            
                            let chk: AnyObject? = data.valueForKey("items")
                            
                            if(chk?.count == 0) {
                                cartItems = data.valueForKey("items") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateDisplay()
                                })
                            } else {
                                cartItems = data.valueForKey("items") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateDisplay()
                                })
                            }
                            
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
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
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
                        print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            
                            let data = post["data"] as! NSDictionary
                            
                            let chk: AnyObject? = data.valueForKey("members")
                            
                            if(chk?.count == 0) {
                                members = NSArray()
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateDisplay()
                                })
                            } else {
                                members = data.valueForKey("members") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateProfileScroll()
                                    self.tempUserId = members[0].objectForKey("userId") as! Double
                                    self.getCartList(members[0].objectForKey("userId") as! Double)
                                })
                            }
                            
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
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
    
    func getOtherCartList(sender: AnyObject) {
        if(sender.tag == 0) {
            tempUserChk = false
        } else {
            tempUserChk = true
        }
        profileName.text = members[sender.tag].objectForKey("userName") as? String
        
        for (var index = 0; index < imageList.count; ++index) {
            
            let profile = profileList[index]

            if (index == sender.tag) {
                profile.image = imageList[sender.tag] as? UIImage
            } else {
                profile.image = grayImageList[index] as? UIImage
            }

            
        }
        tempUserId = members[sender.tag].objectForKey("userId") as! Double
        self.getCartList(tempUserId)
    }
    
    func changeCartItem(sender : AnyObject?) {
        print(sender!.tag)
        
        let index = abs(sender!.tag)
        
        //카트 아이템 수량 변경
        let url: String = serverURL + "user/cartItem/quantity"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let cartItemId = cartItems[index - 1].objectForKey("cartItemId") as! Double
        var quantity = cartItems[index - 1].objectForKey("quantity") as! Int
        
        //카트 아이템별 수량증가
        if(sender!.tag >= 0) {
            amountList[index - 1].text = (quantity + 1).description
            quantity += 1
        } else {
            
            quantity -= 1
            
            if(quantity < 1) {
                //삭제한다.
                quantity = 0
            }
        }
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "cartItemId": cartItemId, "quantity" : quantity]
        
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

                            self.getCartList(members[0].objectForKey("userId") as! Double)
                            
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
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
    
    func makeCartOrder(sender : AnyObject?) {
        //카트아이템 주문
        let url: String = serverURL + "user/cart/order"
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
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공

                            dispatch_async(dispatch_get_main_queue(), {
                                cartItems = NSArray()
                                cartImageList.removeAllObjects()
                                makeOrderFlag = true
                                customPop.showInView(self.view, withMessage: "Your order has been processed. You will be served shortly.", animated: true)
                            })
                            
                        } else if(status == 313){
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            //Have not check in
                            dispatch_async(dispatch_get_main_queue(), {
                                notCheck = true
                                customPop.showInView(self.view, withMessage: "Have not check in. Please table check in again.", animated: true)
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
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
    
    func callFoodOptionView(sender : AnyObject?) {

        let ingredients = cartItems[sender!.tag].objectForKey("excludes") as? NSArray
        let addOns = cartItems[sender!.tag].objectForKey("toppings") as? NSArray
        let options = cartItems[sender!.tag].objectForKey("options") as? NSArray
        
        if(ingredients!.count == 0 && addOns!.count == 0 && options!.count == 0) {
            dispatch_async(dispatch_get_main_queue(), {
                customPop.showInView(self.view, withMessage: "No option or customisation selected.", animated: true)
            })
            return
        }
        
        cartOptionPop = MyCartOptionPopUp(nibName: "PopupView", bundle: nil)
        cartOptionPop.showInView(self.view, withMessage: "MyCart Option", animated: true, items1: options!, items2: ingredients!, items3: addOns!)
    }
    
    func goPayment() {
        let window = UIApplication.sharedApplication().windows[0]
        let tab : UITabBarController = window.rootViewController as! UITabBarController
        tab.selectedIndex = 2
    }
    
}

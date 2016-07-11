//
//  PaymentDetailController.swift
//  tabb
//
//  Created by LeeDongMin on 12/10/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class PaymentDetailController: UIViewController {

    @IBOutlet weak var detailBack: UIView!
    
    var detailScrollView = UIScrollView()
    var contentView = UIView()
    var slider: CustomUISlider!
    var gratitudeValue = UILabel()
    var gratitudeAmount = UILabel()
    var totalPrice = UILabel()
    var subTotal : Double!
    
    var numbers = [1, 2, 3, 4, 5, 6, 7] //Add your values here
    var oldIndex = 0
    
    var search : SearchViewController!
    
    var resultPayPop : ResultPayReviewController!

    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentDetail = self
        
        billId = paymentCheckData.objectForKey("billId") as? Double
        
        resultPayPop = ResultPayReviewController(nibName: "PopupView", bundle: nil)
        
        //self.navigationController!.navigationItem.backBarButtonItem!.enabled = false
        
        detailScrollView = UIScrollView()
        detailScrollView.backgroundColor = UIColor.clearColor()
        detailScrollView.frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 667) / 736)
        detailBack.addSubview(detailScrollView)
        
        let myProfile = UIImageView()
        
        myProfile.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736, (screen.size.width * 58) / 414, (screen.size.height * 58) / 736)
        myProfile.layer.cornerRadius = myProfile.frame.size.height / 2
        myProfile.clipsToBounds = true
        detailScrollView.addSubview(myProfile)
        
        
        if(imageList.count > 0) {
            myProfile.image = imageList[0] as? UIImage
        } else {
            let loadingView = UIView()
            loadingView.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 11) / 736, width: (screen.size.width * 58) / 414, height: (screen.size.height * 58) / 736)
            loadingView.backgroundColor = UIColor.clearColor()
            detailScrollView.addSubview(loadingView)
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 12) / 414, (screen.size.height * 12) / 736);
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
                activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                loadingView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
            })
            if let url = NSURL(string: (members[0].objectForKey("picture") as? String)!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        
                        let image = UIImage(data: imageData)

                        dispatch_async(dispatch_get_main_queue(), {
                            
                            myProfile.image = image
                            
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        })
                    }
                }
            }
        }
        
        
        
        let myProfileName = UILabel()
        myProfileName.frame = CGRectMake((screen.size.width * 84) / 414, (screen.size.height * 30) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        myProfileName.text = members[0].objectForKey("userName") as? String
        myProfileName.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        myProfileName.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        detailScrollView.addSubview(myProfileName)
        
        let topImage = UIImageView(image: UIImage(named: "bill_top"))
        topImage.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 69) / 736, (screen.size.width * 392) / 414, (screen.size.height * 19) / 736)
        detailScrollView.addSubview(topImage)
        
        contentView = UIView()
        //크기를 가변으로 가야한다.
        contentView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 88) / 736, (screen.size.width * 392) / 414, (screen.size.height * 450) / 736)
        contentView.backgroundColor = UIColor.whiteColor()
        detailScrollView.addSubview(contentView)
        
        let restaurantName = UILabel()
        restaurantName.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 15) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        restaurantName.text = paymentCheckData.objectForKey("restaurantName") as? String
        restaurantName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        restaurantName.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        contentView.addSubview(restaurantName)
 
        let date = UILabel()
        date.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 35) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        date.text = (paymentCheckData.objectForKey("day") as! String)
        date.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        date.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(date)

        let checkInTime = paymentCheckData.objectForKey("checkInTime") as! String

        let checkInDate = UILabel()
        checkInDate.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 55) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        checkInDate.text = "Check-in " + checkInTime
        checkInDate.textColor = UIColorFromHex(0x999999, alpha: 1.0)
        checkInDate.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(checkInDate)
        
        let checkOutDate = UILabel()
        checkOutDate.frame = CGRectMake((screen.size.width * 140) / 414, (screen.size.height * 55) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        checkOutDate.text = "Out " + (paymentCheckData.objectForKey("checkOutTime") as! String)
        checkOutDate.textColor = UIColorFromHex(0x999999, alpha: 1.0)
        checkOutDate.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        contentView.addSubview(checkOutDate)
        
        let otherNames = UILabel()
        otherNames.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 75) / 736, (screen.size.width * 300) / 414, (screen.size.height * 100) / 736)
        otherNames.text = paymentCheckData.objectForKey("memberNames") as? String
        otherNames.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        otherNames.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        otherNames.numberOfLines = 0
        otherNames.lineBreakMode = .ByWordWrapping
        otherNames.sizeToFit()
        contentView.addSubview(otherNames)
        
        let subView_y = otherNames.frame.origin.y + otherNames.frame.size.height + (screen.size.height * 15) / 736
        let lineView_y = (screen.size.height * 48) / 736
        var count : CGFloat = 0
        let line1ImageHeight = (screen.size.height * 2) / 736
        
        let items = paymentCheckData.objectForKey("items") as? NSArray
        
        for(var index = 0; index < items?.count; ++index) {
            
            let lineView = UIView()
            lineView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
            lineView.backgroundColor = UIColor.clearColor()
            contentView.addSubview(lineView)
            
            let payTitle = UILabel()
            payTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 260) / 414, (screen.size.height * 20) / 736)
            payTitle.text = items![index].objectForKey("foodName") as? String
            payTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            payTitle.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            lineView.addSubview(payTitle)
            
            let amount = items![index].objectForKey("amount") as! Double

            let payPrice = UILabel()
            payPrice.frame = CGRectMake((screen.size.width * 281) / 414, (screen.size.height * 13) / 736, (screen.size.width * 100) / 414, (screen.size.height * 20) / 736)
            payPrice.text = amount.format(someDoubleFormat) + "KD"
            payPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            payPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            payPrice.textAlignment = .Right
            lineView.addSubview(payPrice)
            
//            let amount = splitItems[index].objectForKey("amount") as? Double
//            total += amount!
            
            let line1Image = UIImageView(image: UIImage(named: "bill_line1"))
            line1Image.frame = CGRectMake(0, ((screen.size.height * 46) / 736) + subView_y + (lineView_y * count), (screen.size.width * 392) / 414, line1ImageHeight)
            contentView.addSubview(line1Image)
            
            ++count
        }
        
        
        let subView = UIView()
        subView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        subView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(subView)
        
        let subTitle = UILabel()
        subTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        subTitle.text = "SUBTOTAL"
        subTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        subTitle.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        subView.addSubview(subTitle)
        
        let subPrice = UILabel()
        subPrice.frame = CGRectMake((screen.size.width * 261) / 414, (screen.size.height * 13) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)

        subTotal = paymentCheckData.objectForKey("subTotal") as! Double

        subPrice.text = subTotal.format(someDoubleFormat) + "KD"
        
        subPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        subPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        subPrice.textAlignment = .Right
        subView.addSubview(subPrice)
        
        let line2Image = UIImageView(image: UIImage(named: "bill_line2"))
        line2Image.frame = CGRectMake(0, ((screen.size.height * 46) / 736) + subView_y + (lineView_y * count), (screen.size.width * 392) / 414, (screen.size.height * 5) / 736)
        contentView.addSubview(line2Image)
        
        let gratitudeView = UIView()
        gratitudeView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count) + ((screen.size.height * 60) / 736), (screen.size.width * 392) / 414, (screen.size.height * 85) / 736)
        gratitudeView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(gratitudeView)
        
        let gratitudeTitle = UILabel()
        gratitudeTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        gratitudeTitle.text = "Gratitude"
        gratitudeTitle.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        gratitudeTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        gratitudeView.addSubview(gratitudeTitle)
        
        gratitudeValue = UILabel()
        gratitudeValue.frame = CGRectMake((screen.size.width * 211) / 414, (screen.size.height * 13) / 736, (screen.size.width * 60) / 414, (screen.size.height * 20) / 736)
        gratitudeValue.text = "0%"
        gratitudeValue.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        gratitudeValue.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        gratitudeValue.textAlignment = .Right
        gratitudeView.addSubview(gratitudeValue)
        
        gratitudeAmount = UILabel()
        gratitudeAmount.frame = CGRectMake((screen.size.width * 301) / 414, (screen.size.height * 13) / 736, (screen.size.width * 80) / 414, (screen.size.height * 20) / 736)
//        let amount = (subTotal * (Double(10) / 100))
        gratitudeAmount.text = "0KD"
        gratitudeAmount.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        gratitudeAmount.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        gratitudeAmount.textAlignment = .Right
        gratitudeView.addSubview(gratitudeAmount)
        
        slider = CustomUISlider()
        slider.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 57) / 736, (screen.size.width * 370) / 414, (screen.size.height * 24) / 736)
        slider.minimumValue = 0
        slider.maximumValue = 20
        slider.value = 0
        slider.tintColor = UIColorFromHex(0xc13939, alpha: 1.0)
        let slideBounds = CGRect(x: 0, y: 0, width: (screen.size.width * 370) / 414, height: (screen.size.height * 24) / 736)
        slider.trackRectForBounds(slideBounds)
        slider.continuous = true; // false makes it call only once you let go
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        gratitudeView.addSubview(slider)
        
        let totalView = UIView()
        totalView.frame = CGRectMake((screen.size.width * 0) / 414, subView_y + (lineView_y * count) + ((screen.size.height * 140) / 736), (screen.size.width * 392) / 414, (screen.size.height * 58) / 736)
        totalView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(totalView)
        
        let totalTitle = UILabel()
        totalTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 19) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
        totalTitle.text = "TOTAL"
        totalTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        totalView.addSubview(totalTitle)
        
        totalPrice = UILabel()
        totalPrice.frame = CGRectMake((screen.size.width * 261) / 414, (screen.size.height * 19) / 736, (screen.size.width * 120) / 414, (screen.size.height * 20) / 736)
        totalPrice.text = (paymentCheckData.objectForKey("subTotal") as! Double).format(someDoubleFormat) + "KD"
        totalPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalPrice.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        totalPrice.textAlignment = .Right
        totalView.addSubview(totalPrice)
        
        //크기 가변으로 해야 스크롤뷰로 볼수 있다
        contentView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 88) / 736, (screen.size.width * 392) / 414, (totalView.frame.origin.y + totalView.frame.height))
        
        let contentView_y =  (contentView.frame.origin.y + contentView.frame.height)
        
        
        let bottomImage = UIImageView(image: UIImage(named: "bill_bottom"))
        bottomImage.frame = CGRectMake((screen.size.width * 11) / 414, contentView_y, (screen.size.width * 392) / 414, (screen.size.height * 19) / 736)
        detailScrollView.addSubview(bottomImage)
        
        let script = UILabel()
        script.frame = CGRectMake((screen.size.width * 11) / 414, (contentView_y + bottomImage.frame.height), (screen.size.width * 392) / 414, (screen.size.height * 20) / 736)
        script.text = "CHOOSE YOUR PREFERRED PAYMENT OPTION"
        script.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        script.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        script.textAlignment = .Center
        detailScrollView.addSubview(script)
        
        let bottomButtonView = UIView()
        bottomButtonView.frame = CGRectMake(0, (contentView_y + bottomImage.frame.height + script.frame.height + (screen.size.height * 11) / 736), screen.size.width, (screen.size.height * 130) / 736)
        bottomButtonView.backgroundColor = UIColor.clearColor()
        detailScrollView.addSubview(bottomButtonView)
        
        let cash = UIButton()
        let knet = UIButton()
        let prePaid = UIButton()
        
        cash.frame = CGRectMake((screen.size.width * 11) / 414, 0, (screen.size.width * 130) / 414, (screen.size.height * 130) / 736)
        cash.setTitle("CASH", forState: UIControlState.Normal)
        cash.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        cash.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        cash.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        cash.roundCorners(([.BottomLeft, .TopLeft]), radius: (screen.size.width * 3.5) / 414)
        cash.clipsToBounds = true
        cash.tag = 1
        cash.addTarget(self, action: "sendPayment:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomButtonView.addSubview(cash)
        
        let line1 = UIView()
        line1.frame = CGRectMake((screen.size.width * 141) / 414, 0, 1, (screen.size.height * 130) / 736)
        line1.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        bottomButtonView.addSubview(line1)
        
        knet.frame = CGRectMake((screen.size.width * 142) / 414, 0, (screen.size.width * 130) / 414, (screen.size.height * 130) / 736)
        knet.setTitle("KNET", forState: UIControlState.Normal)
        knet.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        knet.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        knet.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        knet.addTarget(self, action: "sendPayment:", forControlEvents: UIControlEvents.TouchUpInside)
        knet.tag = 2
        bottomButtonView.addSubview(knet)
        
        let line2 = UIView()
        line2.frame = CGRectMake((screen.size.width * 272) / 414, 0, 1, (screen.size.height * 130) / 736)
        line2.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        bottomButtonView.addSubview(line2)
        
        prePaid.frame = CGRectMake((screen.size.width * 273) / 414, 0, (screen.size.width * 130) / 414, (screen.size.height * 130) / 736)
        prePaid.setTitle("TABBCredit", forState: UIControlState.Normal)
        prePaid.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        prePaid.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        prePaid.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        prePaid.roundCorners(([.BottomRight, .TopRight]), radius: (screen.size.width * 3.5) / 414)
        prePaid.clipsToBounds = true
        prePaid.tag = 3
        prePaid.addTarget(self, action: "sendPayment:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomButtonView.addSubview(prePaid)
        
        
        //스크롤뷰 contentSize 크기를 정해야 한다.
        let scrollViewContentSize = CGSize(width: screen.size.width, height: bottomButtonView.frame.origin.y + bottomButtonView.frame.height + (screen.size.height * 100) / 736)
        detailScrollView.contentSize = scrollViewContentSize
    }
    
    
    
    func sliderValueChanged(sender: UISlider) {
        let index = (Int)(slider!.value + 0.5);
        slider?.setValue(Float(index), animated: false)

        gratitudeValue.text = index.description + "%"
        
        let amount = (subTotal * (Double(index) / 100))

        gratitudeAmount.text = (round(1000 * amount) / 1000).format(someDoubleFormat) + "KD"
        
        totalPrice.text = ((round(1000 * amount) / 1000) + (paymentCheckData.objectForKey("subTotal") as! Double)).format(someDoubleFormat) + "KD"
    }
    
    func sendPayment(sender: AnyObject?) {
        //Payment
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        //let url: String = serverURL + "user/check/requestPayment"
        let url: String = serverURL + "user/bill/pay"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        var paymentMethod : String!
        
        if(sender?.tag == 1) {
            paymentMethod = "CASH"
        } else if(sender?.tag == 2) {
            paymentMethod = "K_NET"
        } else {
            paymentMethod = "QUICK_PAY"
        }
        
        let amount = (subTotal * (Double(slider.value) / 100))
        
//        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkin" : checkinId, "paymentMethod" : paymentMethod, "gratitude" : amount]
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "billId" : billId, "paymentMethod" : paymentMethod, "gratitude" : amount]
        
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
                            paymentItems = NSArray()
                            paymentImageList.removeAllObjects()
                            
                            self.getEvaluateList()
                        } else if(status == 708) {
                            //빌이 없다.
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                self.backPressed(nil)
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
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
    
    func getEvaluateList() {
        let url: String = serverURL + "user/evaluation/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        //let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId]
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "billId" : billId]
        
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
                            evaluateFoodsItems = post["data"]?.objectForKey("foodItems") as! NSArray
                            evaluateRestaurantItems = post["data"]?.objectForKey("restaurantItems") as! NSArray
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                paymentChk = true
                                self.resultPayPop.showInView(self.view, withMessage: "ResultPay", animated: true)
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
        
        dispatch_async(dispatch_get_main_queue(), {
            hideActivityIndicator(windowView)
        })
    }
    
    @IBAction func backPressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    class CustomUISlider : UISlider {
        override func trackRectForBounds(bounds: CGRect) -> CGRect {
            //keeps original origin and width, changes height, you get the idea
            let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
            super.trackRectForBounds(customBounds)
            return customBounds
        }

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

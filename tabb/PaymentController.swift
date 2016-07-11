//
//  PaymentController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 21..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class PaymentController: UIViewController {
    @IBOutlet weak var paymentBack: UIView!
    
    var totalPrice: UILabel!
    var fixMyCheck: UIButton!
    var profileImage : UIImageView!
    var profileScroll : UIScrollView!
    var paymentScroll : UIClickScrollView!
    
    //Payment Item
    var shareItemView : UIView!
    var shareTitle : UILabel!
    var shareOption : UILabel!
    var sharePrice : UILabel!
    var shareAcceptBtn : UIButton!
    var shareRejectBtn : UIButton!
    
    var paymentItemView : UIView!
    var paymentTitle : UILabel!
    var paymentOption : UILabel!
    var paymentPrice : UILabel!
    var paymentReviewBtn : UIButton!
    var paymentLoading : UIImageView!
    
    var profileName : UILabel!
    
    var splitPop : SplitPopUpController!
    var splitTotalPop : SplitTotalPopUpController!
    var sendFoodReviewPop : SendFoodReviewPopUp!

    var profileList : Array<UIImageView> = []
    var splitLoadings : Array<UIImageView> = []
    var reviewBtns : Array<UIButton> = []
    
    
    var shareList : Array<UIImageView> = []
    var paymentList : Array<UIImageView> = []
    
    var search : SearchViewController!
    
    var callView = UIView()
    
    var billCheckFlag = false
    
    var paymentGuide : PaymentGuidePopUp = PaymentGuidePopUp(nibName: "PopupView", bundle: nil)
    
    
    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)
        
        //self.sendPayment(nil)
        
        //self.performSegueWithIdentifier("paymentDetail", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            showActivityIndicator(windowView)
//            
//        })
        
        paymentGuide = PaymentGuidePopUp(nibName: "PopupView", bundle: nil)
        sendFoodReviewPop = SendFoodReviewPopUp(nibName: "PopupView", bundle: nil)

        profileList = []
        
        payment = self
        
        paymentScroll = UIClickScrollView()
        paymentScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 138) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 485) / 736)
        paymentScroll.delaysContentTouches = false
        paymentScroll.showsVerticalScrollIndicator = false
        paymentBack.addSubview(paymentScroll)
        
        profileScroll = UIScrollView()
        profileScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 32) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 92) / 736)
        
        profileName = UILabel()
        profileName.frame = CGRect(x: (screen.size.width * 127) / 414, y: (screen.size.height * 98) / 736, width: (screen.size.width * 160) / 414, height: (screen.size.height * 15) / 736)
        profileName.textColor = UIColor.whiteColor()
        profileName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        profileName.adjustsFontSizeToFitWidth = true
        profileName.textAlignment = .Center
        paymentBack.addSubview(profileName)
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        paymentBack.addSubview(callView)
        
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
        
        //paymentScroll.removeFromSuperview()
        
        let subViews = paymentScroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
//        paymentScroll = UIClickScrollView()
//        paymentScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 138) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 485) / 736)
//        paymentScroll.delaysContentTouches = false
//        paymentScroll.showsVerticalScrollIndicator = false
//        paymentBack.addSubview(paymentScroll)
        
        //self.getCheckInmemberList()
        
        self.getCheckMyBill()

    }
    
    func updateDisplay() {
        
        print("payment updateDisplay()")
        
        splitLoadings.removeAll()
        reviewBtns.removeAll()
        
        //paymentScroll.removeFromSuperview()
        
        let subViews = paymentScroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
//        paymentScroll = UIClickScrollView()
//        paymentScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 138) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 485) / 736)
//        paymentScroll.delaysContentTouches = false
//        paymentScroll.showsVerticalScrollIndicator = false
//        paymentBack.addSubview(paymentScroll)
//        
        
//        callView.removeFromSuperview()
//        
//        callView = UIView()
//        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
//        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
//        callView.layer.cornerRadius = callView.frame.size.width / 2
//        paymentBack.addSubview(callView)
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
        
        if(shareRequestItems.count <= 0) {
            if (paymentItems.count <= 0) {
                print("paymentitems 0")
                let tabbLogo = UIImageView(image: UIImage(named: "logo"))
                tabbLogo.frame = CGRect(x: (screen.size.width * 153) / 414, y: 0 , width: (screen.size.width * 85) / 414, height: (screen.size.height * 85) / 736)
                paymentScroll.addSubview(tabbLogo)
                
                let tabbNotPaymentContent = UITextView()
                tabbNotPaymentContent.frame = CGRect(x: (screen.size.width * 76) / 414, y: (screen.size.height * 105) / 736 , width: (screen.size.width * 240) / 414, height: (screen.size.height * 85) / 736)
                tabbNotPaymentContent.text = "No outstanding bill."
                tabbNotPaymentContent.backgroundColor = UIColor.clearColor()
                tabbNotPaymentContent.editable = false
                tabbNotPaymentContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
                tabbNotPaymentContent.textColor = UIColorFromHex(0x999999, alpha: 1.0)
                tabbNotPaymentContent.textAlignment = .Center
                paymentScroll.addSubview(tabbNotPaymentContent)
                
                return;
            
            
            }
        }
        
        var count : CGFloat = 0
        
        var shareImageCount = 0;
        for(var indexShare = 0; indexShare < shareRequestItems.count; indexShare++) {
            
            shareItemView = UIView()
            shareItemView.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count, width: (screen.size.width * 392) / 414, height: (screen.size.height * 77) / 736)
            let type = (shareRequestItems[indexShare].objectForKey("type") as? String)!
            if(type == "SPLIT") {
                shareItemView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
            } else {
                shareItemView.backgroundColor = UIColorFromHex(0xff9c26, alpha: 1.0)
            }
            shareItemView.layer.borderWidth = 1
            shareItemView.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
            paymentScroll.addSubview(shareItemView)
            
            let shareImage = UIImageView()
            shareImage.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            shareItemView.addSubview(shareImage)
            
            shareList.append(shareImage)
            
            if(shareImageList.count == 0) {
                
            }
            
            let loadingView = UIView()
            loadingView.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            loadingView.backgroundColor = UIColor.clearColor()
            shareItemView.addSubview(loadingView)
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 22) / 414, (screen.size.height * 22) / 736);
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                loadingView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
            })
            if let url = NSURL(string: (shareRequestItems[indexShare].objectForKey("picture") as? String)!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        ++shareImageCount
                        shareImage.image = UIImage(data: imageData)
                        dispatch_async(dispatch_get_main_queue(), {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        })
                    }
                }
            }
            
            shareTitle = UILabel()
            shareTitle.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 8) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            shareTitle.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
            shareTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
            shareTitle.backgroundColor = UIColor.clearColor()
            shareTitle.adjustsFontSizeToFitWidth = true
            if(type == "SPLIT") {
                shareTitle.text = shareRequestItems[indexShare].objectForKey("foodName") as? String
            } else {
                shareTitle.text = (shareRequestItems[indexShare].objectForKey("requesterName") as? String)! + "'s bill"
            }
            
            shareItemView.addSubview(shareTitle)
            
            shareOption = UILabel()
            shareOption.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 28) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            shareOption.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
            shareOption.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            shareOption.backgroundColor = UIColor.clearColor()
            shareOption.adjustsFontSizeToFitWidth = true
            
            shareItemView.addSubview(shareOption)
            
            
            sharePrice = UILabel()
            sharePrice.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 48) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            sharePrice.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
            sharePrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            sharePrice.backgroundColor = UIColor.clearColor()
            sharePrice.adjustsFontSizeToFitWidth = true
            
            shareItemView.addSubview(sharePrice)
            
            let amount = shareRequestItems[indexShare].objectForKey("amount") as! Double
            
            if(type == "SPLIT") {
                shareOption.text = (shareRequestItems[indexShare].objectForKey("requesterName") as? String)! + " want share this dish"
                sharePrice.text = (round(amount * 100) / 100).description + " KD FOR EACH"
            } else if(type == "IMPORTS"){
                shareOption.text = "Your pay send " + (shareRequestItems[indexShare].objectForKey("requesterName") as? String)! + "?"
                sharePrice.text = "TOTAL " + (round(amount * 100) / 100).description + " KD"
            } else {
                shareOption.text = "Are you pay for " + (shareRequestItems[indexShare].objectForKey("requesterName") as? String)! + "'s food?"
                sharePrice.text = "TOTAL " + (round(amount * 100) / 100).description + " KD"
            }
            
            let shareRejectBtn = UIButton()
            shareRejectBtn.frame = CGRect(x: (screen.size.width * 300) / 414, y: (screen.size.height * 25) / 736, width: (screen.size.width * 27) / 414, height: (screen.size.height * 27) / 736)
            shareRejectBtn.setBackgroundImage(UIImage(named: "btn_x"), forState: UIControlState.Normal)
            shareRejectBtn.addTarget(self, action: "sendSplit:", forControlEvents: UIControlEvents.TouchUpInside)
            shareRejectBtn.tag = -(indexShare + 1)
            shareItemView.addSubview(shareRejectBtn)
            
            let  shareAcceptBtn = UIButton()
            shareAcceptBtn.frame = CGRect(x: (screen.size.width * 346) / 414, y: (screen.size.height * 25) / 736, width: (screen.size.width * 27) / 414, height: (screen.size.height * 27) / 736)
            shareAcceptBtn.setBackgroundImage(UIImage(named: "btn_check"), forState: UIControlState.Normal)
            shareAcceptBtn.addTarget(self, action: "sendSplit:", forControlEvents: UIControlEvents.TouchUpInside)
            shareAcceptBtn.tag = (indexShare + 1)
            shareItemView.addSubview(shareAcceptBtn)
            
            count++;
            
            
            let responseType = (shareRequestItems[indexShare].objectForKey("responseType") as? String)!
            
            if(responseType == "WAIT") {
                shareAcceptBtn.hidden = false
                shareRejectBtn.hidden = false
            } else {
                shareAcceptBtn.hidden = true
                shareRejectBtn.hidden = true
            }
        }
        
        var myCheckHeight : CGFloat = 0;
        
        if (shareRequestItems.count > 0) {
            
            if(count > 0) {

            let myCheckTitle = UILabel()
            myCheckTitle.frame = CGRect(x: (screen.size.width * 57) / 414, y: ((screen.size.height * 77) / 736) * count + (screen.size.height * 10) / 736, width: (screen.size.width * 300) / 414, height: (screen.size.height * 20) / 736)
            paymentScroll.addSubview(myCheckTitle)
            myCheckTitle.text = "ACCEPT OTHERS REQUEST OR NOT"
            myCheckTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            myCheckTitle.font = UIFont(name: lato, size: (screen.size.width * 14) / 414)
            myCheckTitle.textAlignment = .Center
            
            let myCheckImage = UIImageView(image: UIImage(named: "icon_below"))
            myCheckImage.frame = CGRect(x: (screen.size.width * 198.5) / 414, y: ((screen.size.height * 77) / 736) * count + (screen.size.height * 40) / 736, width: (screen.size.width * 17) / 414, height: (screen.size.height * 10) / 736)
            paymentScroll.addSubview(myCheckImage)
            
            myCheckHeight = (screen.size.height * 60) / 736
            }
        }
        
        var paymentImageCount = 0;
        var total : Double = 0
        paymentList.removeAll()
        for(var index = 0 ; index < paymentItems.count; index++) {
            paymentItemView = UIView()
            paymentItemView.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count + myCheckHeight, width: (screen.size.width * 392) / 414, height: (screen.size.height * 77) / 736)
            paymentItemView.backgroundColor = UIColor.whiteColor()
            paymentItemView.layer.borderWidth = 0.5
            paymentItemView.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
            paymentScroll.addSubview(paymentItemView)
            
            let paymentImage = UIImageView()
            paymentImage.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            paymentItemView.addSubview(paymentImage)
            
            paymentList.append(paymentImage)
            
            if(paymentImageList.count == paymentItems.count) {
                paymentImage.image = paymentImageList[index] as? UIImage
            } else {
                paymentImageList.removeAllObjects()
                
                let loadingView = UIView()
                loadingView.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
                loadingView.backgroundColor = UIColor.clearColor()
                paymentItemView.addSubview(loadingView)
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
                dispatch_async(dispatch_get_main_queue(), {
                    activityIndicator.frame = CGRectMake(0.0, 0.0, (screen.size.width * 22) / 414, (screen.size.height * 22) / 736);
                    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
                    loadingView.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    
                })
                if let url = NSURL(string: (paymentItems[index].objectForKey("picture") as? String)!) {
                    let request = NSURLRequest(URL: url)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                        if let imageData = data as NSData? {
                            ++paymentImageCount
                            paymentImage.image = UIImage(data: imageData)
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if(paymentImageCount == paymentItems.count) {
                                    
                                    //gray image add list
                                    for(var x=0; x<paymentImageCount; ++x) {
                                        
                                        paymentImageList.addObject(self.paymentList[x].image!)
                                    }
                                    
                                }
                                
                                activityIndicator.stopAnimating()
                                activityIndicator.removeFromSuperview()
                            })
                        }
                    }
                }
                
            }
            
            paymentTitle = UILabel()
            paymentTitle.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 8) / 736, width: (screen.size.width * 240) / 414, height: (screen.size.height * 20) / 736)
            paymentTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            paymentTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
            paymentTitle.backgroundColor = UIColor.clearColor()
            paymentTitle.numberOfLines = 1
            paymentTitle.text = paymentItems[index].objectForKey("foodName") as? String
            paymentItemView.addSubview(paymentTitle)
            
            paymentOption = UILabel()
            paymentOption.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 28) / 736, width: (screen.size.width * 240) / 414, height: (screen.size.height * 20) / 736)
            paymentOption.textColor = UIColorFromHex(0x888888, alpha: 1.0)
            paymentOption.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            paymentOption.backgroundColor = UIColor.clearColor()
            paymentOption.adjustsFontSizeToFitWidth = true
            
            let quantity = paymentItems[index].objectForKey("quantity") as! Int
            let unitPrice = paymentItems[index].objectForKey("unitPrice") as! Double
            let amount = paymentItems[index].objectForKey("amount") as! Double
            
            if((unitPrice * Double.init(quantity)) == amount) {
                paymentOption.text = "Qty : " + quantity.description
            } else {
                paymentOption.text = ""
            }

            paymentItemView.addSubview(paymentOption)
            
            
            paymentPrice = UILabel()
            paymentPrice.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 48) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            paymentPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            paymentPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            paymentPrice.backgroundColor = UIColor.clearColor()
            paymentPrice.adjustsFontSizeToFitWidth = true
         
            
            paymentPrice.text = amount.format(someDoubleFormat) + " KD"
            
            paymentItemView.addSubview(paymentPrice)
            
            total = total + (paymentItems[index].objectForKey("amount") as? Double)!
            
            let paySplitBtn = UIButton()
            paySplitBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            paySplitBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: UIControlState.Normal)
            paySplitBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.5)), forState: UIControlState.Highlighted)
            paySplitBtn.addTarget(self, action: "showSplitPopup:", forControlEvents: UIControlEvents.TouchUpInside)
            paySplitBtn.tag = index
            paymentItemView.addSubview(paySplitBtn)
            
            paymentReviewBtn = UIButton()
            paymentReviewBtn.frame = CGRect(x: (screen.size.width * 346) / 414, y: (screen.size.height * 25) / 736, width: (screen.size.width * 27) / 414, height: (screen.size.height * 27) / 736)
            paymentReviewBtn.setBackgroundImage(UIImage(named: "icon_write"), forState: UIControlState.Normal)
            paymentReviewBtn.addTarget(self, action: "showReviewPopup:", forControlEvents: UIControlEvents.TouchUpInside)
            paymentReviewBtn.tag = index
            paymentItemView.addSubview(paymentReviewBtn)
            
            reviewBtns.append(paymentReviewBtn)
            
            paymentLoading = UIImageView()
            paymentLoading.frame = CGRect(x: (screen.size.width * 346) / 414, y: (screen.size.height * 25) / 736, width: (screen.size.width * 27) / 414, height: (screen.size.height * 27) / 736)
            paymentLoading.tag = index
            paymentLoading.animationImages = self.getAnimationImageArray()	// 애니메이션 이미지
            paymentLoading.animationDuration = 1.0
            paymentLoading.animationRepeatCount = 0	// 0일 경우 무한반복
            paymentItemView.addSubview(paymentLoading)
            
            splitLoadings.append(paymentLoading)
            
            let status = (paymentItems[index].objectForKey("status")?.description)!
            let comment = paymentItems[index].objectForKey("comment") as! Bool
            
            //전체 스플릿시에는 상대방이 스플릿해서 리뷰버튼이 안보인다해도 애니메이션은 돌아야지 나중에 푸시에서 오류가 안난다.
            if(status == "SPLIT_WAIT") {
                if(comment) {
                    splitAttemptChk = true
                    paymentReviewBtn.hidden = true
                    paymentLoading.hidden = false
                    paymentLoading.startAnimating()
                } else {
                    paymentReviewBtn.hidden = true
                    paymentLoading.hidden = true
                }
                
                ++splitSendBillFoodCount;

            } else {
                paymentReviewBtn.hidden = false
                paymentLoading.hidden = true
                paymentLoading.stopAnimating()

                //상대방이 스플릿해서 나에게 추가된 아이템은 리뷰버튼을 없앤다.
                //내가 주문한것이 아니라서 리뷰를쓸수가 없다.
                if(comment) {
                    paymentReviewBtn.hidden = false
                    paymentLoading.hidden = true
                } else {
                    paymentReviewBtn.hidden = true
                    paymentLoading.hidden = true
                }
            }

            //paymentLoading.startAnimating()
            
            
            count++;
        }
        
        if(splitSendBillFoodCount > 1) {
            splitSendBillChk = true
            splitAttemptChk = false
            for(var x = 0; x < splitLoadings.count; x++) {
                splitLoadings[x].hidden = false
                splitLoadings[x].startAnimating()
            }
            
            for(var x = 0; x < reviewBtns.count; x++) {
                reviewBtns[x].hidden = true
            }
        } else if(splitSendBillFoodCount == 1){
            splitAttemptChk = true
        }

        totalPrice = UILabel()
        totalPrice.frame = CGRect(x: 0, y: ((screen.size.height * 77) / 736) * count + myCheckHeight, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
        totalPrice.layer.borderWidth = 1
        totalPrice.layer.borderColor = UIColorFromHex(0x666666, alpha: 1.0).CGColor
        totalPrice.textAlignment = .Center
        totalPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalPrice.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
        totalPrice.backgroundColor = UIColor.whiteColor()
        totalPrice.text = "TOTAL " + total.format(someDoubleFormat) + " KD"
        paymentScroll.addSubview(totalPrice)
        
        //Button Effect
        fixMyCheck = UIButton()
        fixMyCheck.frame = CGRect(x: 0, y: (((screen.size.height * 77) / 736) * count) + totalPrice.frame.size.height + myCheckHeight, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
        fixMyCheck.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 1.0)), forState: UIControlState.Normal)
        fixMyCheck.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.6)), forState: UIControlState.Highlighted)
        fixMyCheck.roundCorners(([.BottomRight, .BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        fixMyCheck.clipsToBounds = true
        fixMyCheck.setTitle("PAY", forState: .Normal)
        fixMyCheck.titleLabel?.textColor = UIColor.whiteColor()
        fixMyCheck.titleLabel?.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
        fixMyCheck.addTarget(self, action: "sendCheckPayment:", forControlEvents: .TouchUpInside)
        paymentScroll.addSubview(fixMyCheck)
        
        //스크롤 사이즈
        paymentScroll.contentSize = CGSize(width: (screen.size.width * 392) / 414, height: (((screen.size.height * 77) / 736) * count) + totalPrice.frame.size.height + fixMyCheck.frame.size.height + myCheckHeight)
        
        //가이드 화면 띄워준다.
        
        if(!pref.boolForKey("guideCheck")) {
            paymentGuide.showInView(self.view, withMessage: "Payment Guide View", animated: true)
        }

    }
    
    func getAnimationImageArray() -> [UIImage] {
        var animationArray: [UIImage] = []
        animationArray.append(UIImage(named: "ani_prog1")!)
        animationArray.append(UIImage(named: "ani_prog2")!)
        animationArray.append(UIImage(named: "ani_prog3")!)
        animationArray.append(UIImage(named: "ani_prog4")!)
        animationArray.append(UIImage(named: "ani_prog5")!)
        
        return animationArray
    }
    
    func updateProfileScroll() {
        //scrolling pageview
        
        if(members.count <= 0) {
            
            let tabbLogo = UIImageView(image: UIImage(named: "logo"))
            tabbLogo.frame = CGRect(x: (screen.size.width * 153) / 414, y: 0 , width: (screen.size.width * 85) / 414, height: (screen.size.height * 85) / 736)
            paymentScroll.addSubview(tabbLogo)
            
            let tabbNotPaymentContent = UITextView()
            tabbNotPaymentContent.frame = CGRect(x: (screen.size.width * 76) / 414, y: (screen.size.height * 105) / 736 , width: (screen.size.width * 240) / 414, height: (screen.size.height * 85) / 736)
            tabbNotPaymentContent.text = "You haven't ordered any food yet."
            tabbNotPaymentContent.backgroundColor = UIColor.clearColor()
            tabbNotPaymentContent.editable = false
            tabbNotPaymentContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            tabbNotPaymentContent.textColor = UIColorFromHex(0x999999, alpha: 1.0)
            tabbNotPaymentContent.textAlignment = .Center
            paymentScroll.addSubview(tabbNotPaymentContent)
            
            return;
        }
        profileScroll.removeFromSuperview()
        profileScroll = UIScrollView()
        profileScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 32) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 92) / 736)

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
        
        profileList.removeAll()

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
            profileBtn.layer.cornerRadius = loadingView.frame.size.height / 2
            profileBtn.clipsToBounds = true
            profileBtn.addTarget(self, action: "showTotalSplit:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func colorButtonsView(buttonSize:CGSize, buttonCount:Int) -> UIView {
        //creates color buttons in a UIView
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.clearColor()
        buttonView.frame.origin = CGPointMake(0,0)
        let padding = CGSizeMake(10, 10)
        buttonView.frame.size.width = (buttonSize.width + padding.width) * CGFloat(buttonCount)
        buttonView.frame.size.height = (buttonSize.height +  2.0 * padding.height)
        
        //add buttons to the view
        var buttonPosition = CGPointMake(padding.width * 0.5, padding.height)
        let buttonIncrement = buttonSize.width + padding.width
        let hueIncrement = 1.0 / CGFloat(buttonCount)
        var newHue = hueIncrement
        
        for _ in 0...(buttonCount - 1)  {
            let button = UIButton(type: .Custom) as UIButton
            button.frame.size = buttonSize
            button.frame.origin = buttonPosition
            buttonPosition.x = buttonPosition.x + buttonIncrement
            button.backgroundColor = UIColor(hue: newHue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            button.layer.borderColor = UIColorFromHex(0x333333, alpha: 1.0).CGColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = button.frame.size.height / 2
            button.clipsToBounds = true
            newHue = newHue + hueIncrement
            button.addTarget(self, action: "showTotalSplit:", forControlEvents: .TouchUpInside)
            buttonView.addSubview(button)
        }
        
        return buttonView
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
    
    func showReviewPopup(sender: AnyObject?) {
        
        checkItemId = paymentItems[(sender?.tag)!].objectForKey("checkItemId") as? Double
        
        let url: String = serverURL + "user/evaluation/viewPost"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkItemId": checkItemId]
        
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
                            
                            foodReviewData = post["data"] as! NSDictionary
                            dispatch_async(dispatch_get_main_queue(), {
                                self.sendFoodReviewPop.showInView(self.view, withMessage: "SendFoodReview", animated: true)
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
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    func showSplitPopup(sender: AnyObject?) {
        
        print(splitAttemptChk)
        print(splitSendBillChk)
        
        if(splitAttemptChk) {
            customPop.showInView(self.view, withMessage: "다른 음식을 스플릿 중입니다. 스플릿 종료후에 다시 시도하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        if(splitSendBillChk) {
            customPop.showInView(self.view, withMessage: "다른 음식을 스플릿 중입니다. 스플릿 종료후에 다시 시도하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        tagNum = (sender?.tag)!
        splitPop = SplitPopUpController(nibName: "PopupView", bundle: nil)
        checkItemId = paymentItems[(sender?.tag)!].objectForKey("checkItemId") as? Double
        splitPop.showInView(self.view, withMessage: "SplitPopUp", animated: true)
        
    }
    
    func showTotalSplit(sender: AnyObject?) {
       
        if(sender!.tag == 0) {
            return;
        }
        
        if(splitAttemptChk) {
            customPop.showInView(self.view, withMessage: "다른 음식을 스플릿 중입니다. 스플릿 종료후에 다시 시도하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        if(splitSendBillChk) {
            customPop.showInView(self.view, withMessage: "다른 음식을 스플릿 중입니다. 스플릿 종료후에 다시 시도하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        splitTotalPop = SplitTotalPopUpController(nibName: "PopupView", bundle: nil)
        otherIndex = sender!.tag
        otherCheckinId = members[sender!.tag].objectForKey("checkinId") as! Double
        self.getOtherPaymentList(members[sender!.tag].objectForKey("checkinId") as! Double)
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
                                splitSendBillFoodCount = 0
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    hideActivityIndicator(windowView)
                                    self.updateDisplay()
                                    
                                })
                                
                            } else {
                                members = data.valueForKey("members") as! NSArray

                                dispatch_async(dispatch_get_main_queue(), {
                                    if(self.billCheckFlag) {
                                        self.performSegueWithIdentifier("paymentDetail", sender: nil)
                                    }else {
                                        self.updateProfileScroll()
                                        self.paymentList(members[0].objectForKey("checkinId") as! Double)
                                    }
                                    
                                })
                            }
                            
                        } else if(status == 405){
                            dispatch_async(dispatch_get_main_queue(), {
                                paymentItems = NSArray()
                                shareRequestItems = NSArray()
                                members = NSArray()
                                hideActivityIndicator(windowView)
                                self.updateDisplay()
                                
                            })
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                paymentItems = NSArray()
                                shareRequestItems = NSArray()
                                members = NSArray()
                                hideActivityIndicator(windowView)
                                self.updateDisplay()
                                
                            })
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    func paymentList(checkinId : Double) {
        let url: String = serverURL + "user/check/list"
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
                            
                            let chk: AnyObject? = data.valueForKey("items")
                            let chk1: AnyObject? = data.valueForKey("shareRequestItems")
                            splitSendBillFoodCount = 0
                            
                            if(chk?.count == 0) {
                                
                                if(chk1?.count == 0) {
                                    checkId = 0
                                    paymentItems = NSArray()
                                    shareRequestItems = NSArray()
                                    dispatch_async(dispatch_get_main_queue(), {
                                        hideActivityIndicator(windowView)
                                        self.updateDisplay()
                                    })
                                } else {
                                    checkId = data.valueForKey("checkId") as! Double
                                    paymentItems = NSArray()
                                    shareRequestItems = data.valueForKey("shareRequestItems") as! NSArray
                                    dispatch_async(dispatch_get_main_queue(), {
                                        hideActivityIndicator(windowView)
                                        self.updateDisplay()
                                    })
                                }
                                
                            } else {
                                checkId = data.valueForKey("checkId") as! Double
                                paymentItems = data.valueForKey("items") as! NSArray
                                shareRequestItems = data.valueForKey("shareRequestItems") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    hideActivityIndicator(windowView)
                                    self.updateDisplay()
                                })
 
                            }
                            
                        } else if(status == 502){
                            
                            checkId = 0
                            paymentItems = NSArray()
                            shareRequestItems = NSArray()
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                self.updateDisplay()
                            })
                            
                            
                        } else if(status == 506){
                            //내가 가진 bill이 있을 경우??
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                            })
                            
                        } else if(status == 313){
                            //Have Not Check In
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            checkId = 0
                            paymentItems = NSArray()
                            shareRequestItems = NSArray()
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                self.updateDisplay()
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    func getOtherPaymentList(checkinId : Double) {
        
        let url: String = serverURL + "user/check/simple"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId": checkinId]
        
        print(newPost)
        
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
                                dispatch_async(dispatch_get_main_queue(), {
                                    hideActivityIndicator(windowView)
                                })
                            } else {
                                splitUserName = data.valueForKey("userName") as! String
                                splitItems = data.valueForKey("items") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    hideActivityIndicator(windowView)
                                    self.splitTotalPop.showInView(self.view, withMessage: "SplitPopUp", animated: true)
                                })
                                
                                
                            }
                            
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
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    func sendCheckPayment(sender: AnyObject?) {
        //Payment
        
//        if(splitAttemptChk) {
//            customPop.showInView(self.view, withMessage: "스플릿을 중입니다. 스플릿 종료후에 다시 시도하여 주시기 바랍니다.", animated: true)
//            return;
//        }
        
        //let url: String = serverURL + "user/check/requestCheck"
        let url: String = serverURL + "user/check/requestBill"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId]
        
        print("sendCheckPayment \(newPost)")
        
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
                            paymentCheckData = post["data"] as! NSDictionary
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSegueWithIdentifier("paymentDetail", sender: nil)
                            })
                            
                            
                        } else if(status == 604){
                            
                            customPop.showInView(self.view, withMessage: "스플릿 중입니다. 스플릿 종료후에 다시 시도하여 주시기 바랍니다.", animated: true)
                            
                        } else if(status == 508){
                            //Duplication Request For Making Bill.
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
    
    
    func sendSplit(sender: AnyObject?) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            showActivityIndicator(windowView)
            
        })

 
        var acceptChk = false
        if(sender!.tag > 0) {
            acceptChk = true
        } else {
            acceptChk = false
        }
        
        
        
        shareRequestId = shareRequestItems[(abs(sender!.tag) - 1)].objectForKey("shareRequestId") as! Double
        
        let url: String = serverURL + "user/shareRequest/response"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId, "sharedRequestId" : shareRequestId, "accept" : acceptChk]
        
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

                            dispatch_async(dispatch_get_main_queue(), {
                                //hideActivityIndicator(windowView)

                                splitAttemptChk = false
                                splitSendBillChk = false

                                
                                self.paymentList(members[0].objectForKey("checkinId") as! Double)
                                
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
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            
                        })
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    //결제가 완료되지 않고 앱이 종료 됐을 시에 검색한다.
    func getCheckMyBill() {
        let url: String = serverURL + "user/bill/find"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId]
        print(newPost)
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
                            
                            paymentCheckData = post["data"] as! NSDictionary
                            self.billCheckFlag = true
                            self.getCheckInmemberList()
                            
                            
                        } else if(status == 707){
                            //Not Found Bill
                            //getCheckMembers
                            self.billCheckFlag = false
                            self.getCheckInmemberList()
                        } else if(status == 405){
                            //Not Found CheckIn
                            self.billCheckFlag = false
                            self.getCheckInmemberList()
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        } else if(status == 708) {
                            //빌이 없다.
                            self.billCheckFlag = false
                            self.getCheckInmemberList()
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
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
    
    func updatePushChange() {
        self.paymentList(members[0].objectForKey("checkinId") as! Double)
    }
    
    func changeLoadings() {
        reviewBtns[tagNum].hidden = true
        splitLoadings[tagNum].hidden = false
        splitLoadings[tagNum].startAnimating()
    }
    
    func changeReviewBtn() {
        splitSendBillFoodCount = 0
        splitAttemptChk = false
        splitLoadings[tagNum].stopAnimating()
        splitLoadings[tagNum].hidden = true
        reviewBtns[tagNum].hidden = false
        
        self.paymentList(members[0].objectForKey("checkinId") as! Double)
    }
    
    func changeAllLoadings() {
        for(var x = 0; x < splitLoadings.count; x++) {
            splitLoadings[x].hidden = false
            splitLoadings[x].startAnimating()
        }
        
        for(var x = 0; x < reviewBtns.count; x++) {
            reviewBtns[x].hidden = true
        }
    }
    
    func changeAllReviewBtn() {
        splitSendBillFoodCount = 0
        splitSendBillChk = false
        splitAttemptChk = false
//        for(var x = 0; x < splitLoadings.count; x++) {
//            splitLoadings[x].hidden = true
//            splitLoadings[x].stopAnimating()
//        }
//        
//        for(var x = 0; x < reviewBtns.count; x++) {
//            reviewBtns[x].hidden = false
//        }
//        
        self.paymentList(members[0].objectForKey("checkinId") as! Double)
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

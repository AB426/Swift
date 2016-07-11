//
//  SplitTotalPopUpController.swift
//  tabb
//
//  Created by LeeDongMin on 12/4/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class SplitTotalPopUpController: UIViewController {
    
    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool) {

        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        self.popUp = UIView()
        let screen: CGRect = UIScreen.mainScreen().bounds
        self.popUp.layer.shadowOpacity = 0.8
        self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.popUp.backgroundColor = UIColor.clearColor()
        self.popUp.frame = CGRectMake(0, 0,  menuWrapperBounds.width, menuWrapperBounds.height)
        
        let profileImg = UIImageView()
        profileImg.frame = CGRectMake((screen.size.width * 178) / 414, (screen.size.height * 95) / 736, (screen.size.width * 58) / 414, (screen.size.height * 58) / 736)
        profileImg.image = imageList[otherIndex] as? UIImage
        profileImg.layer.cornerRadius = profileImg.frame.size.height / 2
        profileImg.backgroundColor = UIColor.clearColor()
        self.popUp.addSubview(profileImg)
        
        let profileName = UILabel()
        profileName.frame = CGRectMake((screen.size.width * 87) / 414, (screen.size.height * 158) / 736, (screen.size.width * 240) / 414, (screen.size.height * 20) / 736)
        profileName.textColor = UIColor.whiteColor()
        profileName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        profileName.adjustsFontSizeToFitWidth = true
        profileName.textAlignment = .Center
        profileName.text = (members[otherIndex].objectForKey("userName") as? String)!
        self.popUp.addSubview(profileName)
        
        
        popUpScrollView = UIScrollView()
        popUpScrollView.backgroundColor = UIColor.clearColor()
        popUpScrollView.frame = CGRectMake(0, (screen.size.height * 183) / 736, screen.size.width, (screen.size.height * 653) / 736)
        self.popUp.addSubview(popUpScrollView)
        
        let close = UIButton()
        close.frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 183) / 736)
        close.backgroundColor = UIColor.clearColor()
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(close)
        
        contentView = UIView()
        //크기를 가변으로 가야한다.
        contentView.frame = CGRectMake((screen.size.width * 11) / 414, 0, (screen.size.width * 392) / 414, (screen.size.height * 384) / 736)
        contentView.backgroundColor = UIColor.whiteColor()
        popUpScrollView.addSubview(contentView)

        //변경된 UI로 스플릿 화면을 만들자. 그러나 아직 개발 전, 서버에서 개발 완료 되면 시작.
        var total : Double = 0
        var count : CGFloat = 0
        let myCheckHeight = (screen.size.height * 0) / 736
        let lineView_y = (screen.size.height * 79) / 736
        let paymentLineHeight : CGFloat = 1
        
        for(var index = 0 ; index < splitItems.count; index++) {
            let paymentLine = UIView()
            paymentLine.frame = CGRectMake(0, (lineView_y * count) + myCheckHeight, (screen.size.width * 392) / 414, paymentLineHeight)
            paymentLine.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
            contentView.addSubview(paymentLine)


            let paymentItemView = UIView()
            paymentItemView.frame = CGRect(x: 0, y: ((screen.size.height * 79) / 736) * count + myCheckHeight + paymentLineHeight, width: (screen.size.width * 392) / 414, height: (screen.size.height * 77) / 736)
            //paymentItemView.backgroundColor = UIColor.whiteColor()
            contentView.addSubview(paymentItemView)
            
            let paymentImage = UIImageView()
            paymentImage.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 77) / 414, height: (screen.size.height * 77) / 736)
            paymentItemView.addSubview(paymentImage)

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
            if let url = NSURL(string: (splitItems[index].objectForKey("picture") as? String)!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        paymentImage.image = UIImage(data: imageData)
                        dispatch_async(dispatch_get_main_queue(), {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        })
                    }
                }
            }
            
            let paymentTitle = UILabel()
            paymentTitle.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 8) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            paymentTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            paymentTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
            paymentTitle.backgroundColor = UIColor.clearColor()
            paymentTitle.adjustsFontSizeToFitWidth = true
            paymentTitle.text = splitItems[index].objectForKey("foodName") as? String
            paymentItemView.addSubview(paymentTitle)
            
            let paymentOption = UILabel()
            paymentOption.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 28) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            paymentOption.textColor = UIColorFromHex(0x888888, alpha: 1.0)
            paymentOption.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            paymentOption.backgroundColor = UIColor.clearColor()
            paymentOption.adjustsFontSizeToFitWidth = true
            
            let quantity = splitItems[index].objectForKey("quantity") as! Int
            let unitPrice = splitItems[index].objectForKey("unitPrice") as! Double
            
            paymentOption.text = "Qty : " + quantity.description
            
            paymentItemView.addSubview(paymentOption)
            
            
            let paymentPrice = UILabel()
            paymentPrice.frame = CGRect(x: (screen.size.width * 92) / 414, y: (screen.size.height * 48) / 736, width: (screen.size.width * 180) / 414, height: (screen.size.height * 20) / 736)
            paymentPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            paymentPrice.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            paymentPrice.backgroundColor = UIColor.clearColor()
            paymentPrice.adjustsFontSizeToFitWidth = true
            
            paymentPrice.text = (splitItems[index].objectForKey("amount") as! Double).format(someDoubleFormat) + " KD"
            
            paymentItemView.addSubview(paymentPrice)
            
            total = total + (splitItems[index].objectForKey("amount") as? Double)!
            
            
            count++;
        }
        
        let totalLine = UIView()
        totalLine.frame = CGRectMake(0, (lineView_y * count) + myCheckHeight, (screen.size.width * 392) / 414, paymentLineHeight)
        totalLine.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        contentView.addSubview(totalLine)
        
        let totalPrice = UILabel()
        totalPrice.frame = CGRect(x: 0, y: totalLine.frame.origin.y + totalLine.frame.size.height, width: (screen.size.width * 392) / 414, height: (screen.size.height * 58) / 736)
        totalPrice.textAlignment = .Center
        totalPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        totalPrice.font = UIFont(name: lato, size: (screen.size.width * 20) / 414)
        totalPrice.backgroundColor = UIColor.whiteColor()
        totalPrice.text = "TOTAL " + total.format(someDoubleFormat) + " KD"
        contentView.addSubview(totalPrice)
        
        
        //크기조정
        contentView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 19) / 736, (screen.size.width * 392) / 414, (totalPrice.frame.origin.y + totalPrice.frame.size.height))
        
        let button_y =  (contentView.frame.origin.y + contentView.frame.size.height)

        let sendBill: UIButton = UIButton()
        let takeBill: UIButton = UIButton()
        
        takeBill.frame = CGRectMake((screen.size.width * 11) / 414, button_y, (screen.size.width * 392) / 414, (screen.size.height * 54) / 736)
        takeBill.setTitle("Move this Bill to my Tab", forState: UIControlState.Normal)
        takeBill.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        takeBill.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#A4A4A4")), forState: .Normal)
        takeBill.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#A4A4A4", alpha: 0.5)), forState: .Highlighted)
        takeBill.clipsToBounds = true
        takeBill.addTarget(self, action: "takeBill:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(takeBill)
        
        sendBill.frame = CGRectMake((screen.size.width * 11) / 414, button_y + takeBill.frame.size.height, (screen.size.width * 392) / 414, (screen.size.height * 54) / 736)
        sendBill.setTitle("Move my Bill to this Tab", forState: UIControlState.Normal)
        sendBill.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        sendBill.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        sendBill.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        sendBill.roundCorners(([.BottomRight, .BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        sendBill.clipsToBounds = true
        sendBill.addTarget(self, action: "sendBill:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(sendBill)
        
        let line = UIView()
        line.frame = CGRectMake((screen.size.width * 11) / 414, button_y + takeBill.frame.size.height, (screen.size.width * 392) / 414, 1)
        line.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        popUpScrollView.addSubview(line)
        
//        let bottomImage = UIImageView(image: UIImage(named: "bill_bottom"))
//        bottomImage.frame = CGRectMake((screen.size.width * 11) / 414, contentView.frame.height + (screen.size.height * 6) / 736, (screen.size.width * 392) / 414, (screen.size.height * 19) / 736)
//        popUpScrollView.addSubview(bottomImage)
        
        self.view.addSubview(self.popUp)
        
        window.addSubview(self.view)
        
        let popUpHeight = sendBill.frame.origin.y + sendBill.frame.size.height + (screen.size.height * 100) / 736
        popUpScrollView.frame = CGRectMake(0, (screen.size.height * 183) / 736, screen.size.width, (screen.size.height * 653) / 736)
        popUpScrollView.contentSize = CGSize(width: screen.size.width, height: popUpHeight)
        
//        if(popUpHeight > screen.size.height) {
//            popUpScrollView.frame = CGRectMake(0, (screen.size.height * 202) / 736, screen.size.width, (screen.size.height * 634) / 736)
//            popUpScrollView.contentSize = CGSize(width: contentView.frame.width, height: popUpHeight)
//        } else {
//            popUpScrollView.frame = CGRectMake(0, (screen.size.height * 202) / 736, screen.size.width, (screen.size.height * 634) / 736)
//            popUpScrollView.contentSize = CGSize(width: contentView.frame.width, height: popUpHeight)
//        }
        
        
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.15, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animateWithDuration(0.15, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func close(sender: AnyObject?) {
        self.removeAnimate()
    }
    
    func sendBill(sender: AnyObject?) {
        let url: String = serverURL + "user/shareRequest/splitCheck"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId, "toCheckInIds" : otherCheckinId]
        
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
                                self.removeAnimate()
                                
                                splitSendBillChk = true
                                if(payment != nil) {
                                    payment.changeAllLoadings()
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
    
    func takeBill(sender: AnyObject?) {
        let url: String = serverURL + "user/shareRequest/imports"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId, "fromCheckInId" : otherCheckinId]
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
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                splitTakeBillChk = true
                                self.removeAnimate()
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
        
        print("server end")
    }
}

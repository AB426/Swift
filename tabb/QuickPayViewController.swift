//
//  QuickPayViewController.swift
//  tabb
//
//  Created by LeeDongMin on 12/24/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class QuickPayViewController: UIViewController {

    @IBOutlet weak var quickPayBack: UIView!
    
    var quickScroll : UIScrollView!
    
    var quickDate : UILabel!
    var quickDateFormatter : NSDateFormatter!
    
    var tempDate : NSDate = NSDate()
    
    var myPoint : UILabel!
    var pointBack : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = UILabel()
        title.frame = CGRectMake((screen.size.width * 31) / 414, (screen.size.height * 31) / 736, (screen.size.width * 200) / 414, (screen.size.height * 30) / 736)
        title.textAlignment = .Left
        title.textColor = UIColor.whiteColor()
        title.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        title.text = "TABBCredit"
        quickPayBack.addSubview(title)
        
        tempDate = NSDate()
        quickDateFormatter = NSDateFormatter()
        quickDateFormatter.dateFormat = "MMM yyyy";
        
        let pointView = UIView()
        pointView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 70) / 736, (screen.size.width * 392) / 414, (screen.size.height * 58) / 736)
        pointView.backgroundColor = UIColorFromHex(0x333333, alpha: 1.0)
        pointView.roundCorners(([.TopLeft, .TopRight]), radius: (screen.size.width * 3.5) / 414)
        quickPayBack.addSubview(pointView)
        
        let content: NSString = NSString(string: (guickPayData.objectForKey("userPoint") as! Int).description)     
        let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize((screen.size.width * 30) / 414)])
        
        myPoint = UILabel()
        myPoint.frame = CGRectMake((screen.size.width * 19) / 414, (screen.size.height * 14) / 736, labelSize.width + 5, (screen.size.height * 30) / 736)
        myPoint.textAlignment = .Left
        myPoint.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        myPoint.font = UIFont(name: roboto, size: (screen.size.width * 30) / 414)
        myPoint.text = content.description
        pointView.addSubview(myPoint)
        
        pointBack = UILabel()
        pointBack.frame = CGRectMake(myPoint.frame.origin.x + myPoint.frame.size.width, (screen.size.height * 24) / 736, (screen.size.width * 60) / 414, (screen.size.height * 20) / 736)
        pointBack.textAlignment = .Left
        pointBack.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        pointBack.font = UIFont(name: roboto, size: (screen.size.width * 18) / 414)
        pointBack.text = "KD"
        pointView.addSubview(pointBack)
        
        let charge = UIButton()
        charge.frame = CGRectMake((screen.size.width * 338) / 414, (screen.size.height * 11.5) / 736, (screen.size.width * 35) / 414, (screen.size.height * 35) / 736)
        charge.setBackgroundImage(UIImage(named: "icon_add2"), forState: .Normal)
        charge.addTarget(self, action: "sendCharge:", forControlEvents: .TouchUpInside)
        pointView.addSubview(charge)
        
        let quickTitleView = UIView()
        quickTitleView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 139) / 736, (screen.size.width * 392) / 414, (screen.size.height * 58) / 736)
        quickTitleView.backgroundColor = UIColor.whiteColor()
        quickTitleView.roundCorners(([.TopLeft, .TopRight]), radius: (screen.size.width * 3.5) / 414)
        quickPayBack.addSubview(quickTitleView)
        
        quickDate = UILabel()
        quickDate.frame = CGRectMake((screen.size.width * 146) / 414, (screen.size.height * 14) / 736, (screen.size.width * 100) / 414, (screen.size.height * 30) / 736)
        quickDate.textAlignment = .Center
        quickDate.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        quickDate.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        quickDate.text = quickDateFormatter.stringFromDate(tempDate)
        quickTitleView.addSubview(quickDate)
        
        let prevMonth = UIButton()
        prevMonth.frame = CGRectMake((screen.size.width * 23) / 414, (screen.size.height * 15.5) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        prevMonth.setBackgroundImage(UIImage(named: "btn_premonth"), forState: .Normal)
        prevMonth.addTarget(self, action: "getCreditHistory:", forControlEvents: UIControlEvents.TouchUpInside)
        prevMonth.tag = 1
        quickTitleView.addSubview(prevMonth)
        
        let nextMonth = UIButton()
        nextMonth.frame = CGRectMake((screen.size.width * 342) / 414, (screen.size.height * 15.5) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        nextMonth.setBackgroundImage(UIImage(named: "btn_nextmonth"), forState: .Normal)
        nextMonth.addTarget(self, action: "getCreditHistory:", forControlEvents: UIControlEvents.TouchUpInside)
        nextMonth.tag = 2
        quickTitleView.addSubview(nextMonth)
        
        quickScroll = UIClickScrollView()
        quickScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 208) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 528) / 736)
        quickScroll.delaysContentTouches = false
        quickScroll.showsVerticalScrollIndicator = false
        quickScroll.roundCorners(([.BottomLeft, .BottomRight]), radius: (screen.size.width * 3.5) / 414)
        quickPayBack.addSubview(quickScroll)
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        quickPayBack.addSubview(callView)
        
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
        
        self.updateDisplay()
    }
    
    func updateDisplay() {
        
        quickDate.text = quickDateFormatter.stringFromDate(tempDate)
        
        let subViews = quickScroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        let tabbLogo = UIImageView(image: UIImage(named: "logo"))
        tabbLogo.frame = CGRect(x: (screen.size.width * 153) / 414, y: (screen.size.height * 10) / 736 , width: (screen.size.width * 85) / 414, height: (screen.size.height * 85) / 736)
        quickScroll.addSubview(tabbLogo)
        
        let tabbNotHistory = UITextView()
        tabbNotHistory.frame = CGRect(x: (screen.size.width * 76) / 414, y: (screen.size.height * 115) / 736 , width: (screen.size.width * 240) / 414, height: (screen.size.height * 85) / 736)
        tabbNotHistory.text = "No TABBCredit purchase this month."
        tabbNotHistory.backgroundColor = UIColor.clearColor()
        tabbNotHistory.editable = false
        tabbNotHistory.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        tabbNotHistory.textColor = UIColorFromHex(0x999999, alpha: 1.0)
        tabbNotHistory.textAlignment = .Center
        quickScroll.addSubview(tabbNotHistory)
    }
    
    func getCreditHistory(sender : AnyObject?) {
        let formatYear = NSDateFormatter()
        formatYear.dateFormat = "yyyy";
        
        let formatMonth = NSDateFormatter()
        formatMonth.dateFormat = "MM";
        
        if(sender!.tag == 1) {
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: tempDate, options: [])
            tempDate = date!
        } else {
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 1, toDate: tempDate, options: [])
            tempDate = date!
        }
        
        searchYear = Int.init(formatYear.stringFromDate(tempDate))!
        searchMonth = Int.init(formatMonth.stringFromDate(tempDate))!
        
        let url: String = serverURL + "user/point/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "year" : searchYear, "month" : searchMonth]
        
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
                            
                            let data = post["data"] as! NSDictionary
                            
                            print("TABBCredit : \(data)")
                            
                            let chk: AnyObject? = data.valueForKey("items")
                            
                            if(chk?.count == 0) {
                                
                                historyData = NSDictionary()
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateDisplay()
                                })
                                
                            } else {
                                historyData = post["data"] as! NSDictionary
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.updateDisplay()
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
    
    func sendCharge(sender : AnyObject?) {
        
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

}

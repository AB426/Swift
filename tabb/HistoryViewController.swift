//
//  HistoryViewController.swift
//  tabb
//
//  Created by LeeDongMin on 12/24/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyBack: UIView!
    
    var historyScroll : UIClickScrollView!
    
    var historyDate : UILabel!
    var historyDateFormatter : NSDateFormatter!
    
    var tempDate : NSDate = NSDate()
    
    var historyDetailPop : HistoryDetailPopUp = HistoryDetailPopUp(nibName: "PopupView", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel()
        title.frame = CGRectMake((screen.size.width * 31) / 414, (screen.size.height * 31) / 736, (screen.size.width * 200) / 414, (screen.size.height * 30) / 736)
        title.textAlignment = .Left
        title.textColor = UIColor.whiteColor()
        title.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        title.text = "History"
        historyBack.addSubview(title)
        
        tempDate = NSDate()
        historyDateFormatter = NSDateFormatter()
        historyDateFormatter.dateFormat = "MMM yyyy";
        
        let historyTitleView = UIView()
        historyTitleView.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 70) / 736, (screen.size.width * 392) / 414, (screen.size.height * 58) / 736)
        historyTitleView.backgroundColor = UIColor.whiteColor()
        historyTitleView.roundCorners(([.TopLeft, .TopRight]), radius: (screen.size.width * 3.5) / 414)
        historyBack.addSubview(historyTitleView)
        
        historyDate = UILabel()
        historyDate.frame = CGRectMake((screen.size.width * 146) / 414, (screen.size.height * 14) / 736, (screen.size.width * 100) / 414, (screen.size.height * 30) / 736)
        historyDate.textAlignment = .Center
        historyDate.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        historyDate.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        //historyDate.text = historyDateFormatter.stringFromDate(tempDate)
        historyTitleView.addSubview(historyDate)
        
        let prevMonth = UIButton()
        prevMonth.frame = CGRectMake((screen.size.width * 23) / 414, (screen.size.height * 15.5) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        prevMonth.setBackgroundImage(UIImage(named: "btn_premonth"), forState: .Normal)
        prevMonth.addTarget(self, action: "getHistory:", forControlEvents: UIControlEvents.TouchUpInside)
        prevMonth.tag = 1
        historyTitleView.addSubview(prevMonth)
        
        let nextMonth = UIButton()
        nextMonth.frame = CGRectMake((screen.size.width * 342) / 414, (screen.size.height * 15.5) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        nextMonth.setBackgroundImage(UIImage(named: "btn_nextmonth"), forState: .Normal)
        nextMonth.addTarget(self, action: "getHistory:", forControlEvents: UIControlEvents.TouchUpInside)
        nextMonth.tag = 2
        historyTitleView.addSubview(nextMonth)
        
        
        
        
        historyScroll = UIClickScrollView()
        historyScroll.frame = CGRect(x: (screen.size.width * 11) / 414, y: (screen.size.height * 128) / 736, width: (screen.size.width * 392) / 414, height: (screen.size.height * 495) / 736)
        historyScroll.delaysContentTouches = false
        historyScroll.showsVerticalScrollIndicator = false
        historyScroll.backgroundColor = UIColor.clearColor()
        historyBack.addSubview(historyScroll)
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        historyBack.addSubview(callView)
        
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
        
        historyDate.text = historyDateFormatter.stringFromDate(tempDate)
        
        let subViews = historyScroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        if(historyData.count > 0) {
            let items = historyData.objectForKey("items") as! NSArray
            
            var total = 0.0;
            var heightCount : CGFloat = 0;
            let viewHeight = (screen.size.height * 70) / 736

            for(var index = 0; index < items.count; index++) {
                let historyView = UIView()
                historyView.frame = CGRectMake(0, viewHeight * heightCount, (screen.size.width * 392) / 414, viewHeight)
                historyView.backgroundColor = UIColor.whiteColor()
                historyView.layer.borderColor = UIColorFromHex(0xcccccc, alpha: 1.0).CGColor
                historyView.layer.borderWidth = (screen.size.width * 1) / 414
                historyScroll.addSubview(historyView)

                let historyBtn = UIButton()
                historyBtn.frame = CGRectMake(0, viewHeight * (heightCount) + (1 * heightCount), (screen.size.width * 392) / 414, viewHeight)
                historyBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0)), forState: .Normal)
                historyBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.5)), forState: .Highlighted)
                historyBtn.addTarget(self, action: "getHistoryDetailView:", forControlEvents: .TouchUpInside)
                historyBtn.tag = index
                historyScroll.addSubview(historyBtn)
                
                let restaurantName = UILabel()
                restaurantName.frame = CGRectMake((screen.size.width * 17) / 414, (screen.size.height * 10) / 736, (screen.size.width * 260) / 414, (screen.size.height * 20) / 736)
                restaurantName.text = items[index].objectForKey("restaurantName") as? String
                restaurantName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                restaurantName.font = UIFont(name: lato, size: (screen.size.width * 17) / 414)
                restaurantName.adjustsFontSizeToFitWidth = true
                historyView.addSubview(restaurantName)
                
                let date = UILabel()
                date.frame = CGRectMake((screen.size.width * 17) / 414, (screen.size.height * 40) / 736, (screen.size.width * 200) / 414, (screen.size.height * 20) / 736)
                date.text = (items[index].objectForKey("day") as! String)
                date.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                date.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                historyView.addSubview(date)
                
                let amount = items[index].objectForKey("amount") as! Double

                let subTotal = UILabel()
                subTotal.frame = CGRectMake((screen.size.width * 285) / 414, (screen.size.height * 10) / 736, (screen.size.width * 90) / 414, (screen.size.height * 20) / 736)
                subTotal.text = amount.format(someDoubleFormat) + "KD"
                subTotal.textAlignment = .Right
                subTotal.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                subTotal.font = UIFont(name: lato, size: (screen.size.width * 17) / 414)
                historyView.addSubview(subTotal)
                
                let checkInDate = UILabel()
                checkInDate.frame = CGRectMake((screen.size.width * 201) / 414, (screen.size.height * 40) / 736, (screen.size.width * 100) / 414, (screen.size.height * 20) / 736)
                checkInDate.text = "CHECK IN " + (items[index].objectForKey("checkInTime") as! String)
                checkInDate.textColor = UIColorFromHex(0x999999, alpha: 1.0)
                checkInDate.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                checkInDate.textAlignment = .Right
                historyView.addSubview(checkInDate)
                
                let checkOutDate = UILabel()
                checkOutDate.frame = CGRectMake((screen.size.width * 310) / 414, (screen.size.height * 40) / 736, (screen.size.width * 65) / 414, (screen.size.height * 20) / 736)
                checkOutDate.text = "OUT " + (items[index].objectForKey("checkOutTime") as! String)
                checkOutDate.textColor = UIColorFromHex(0x999999, alpha: 1.0)
                checkOutDate.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
                checkOutDate.textAlignment = .Right
                historyView.addSubview(checkOutDate)
                
                total += amount
                
                
                ++heightCount;
            }
            
  
            let totalView = UIView()
            totalView.frame = CGRectMake(0, viewHeight * heightCount, (screen.size.width * 392) / 414, (screen.size.height * 50) / 736)
            totalView.backgroundColor = UIColor.whiteColor()
            totalView.roundCorners(([.BottomLeft, .BottomRight]), radius: (screen.size.width * 3.5) / 414)
            historyScroll.addSubview(totalView)
            
            let totalDate = UILabel()
            totalDate.frame = CGRectMake((screen.size.width * 17) / 414, (screen.size.height * 10) / 736, (screen.size.width * 150) / 414, (screen.size.height * 30) / 736)
            totalDate.text = historyDateFormatter.stringFromDate(tempDate)
            totalDate.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            totalDate.font = UIFont(name: latoBold, size: (screen.size.width * 17) / 414)
            totalView.addSubview(totalDate)
            
            let totalValue = UILabel()
            totalValue.frame = CGRectMake((screen.size.width * 225) / 414, (screen.size.height * 10) / 736, (screen.size.width * 150) / 414, (screen.size.height * 30) / 736)
            totalValue.text = total.format(someDoubleFormat) + "KD"
            totalValue.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            totalValue.font = UIFont(name: latoBold, size: (screen.size.width * 17) / 414)
            totalValue.textAlignment = .Right
            totalView.addSubview(totalValue)

            historyScroll.contentSize = CGSize(width: (screen.size.width * 392) / 414, height: totalView.frame.size.height + (viewHeight * heightCount))
            
        } else {
            let tabbLogo = UIImageView(image: UIImage(named: "logo"))
            tabbLogo.frame = CGRect(x: (screen.size.width * 153) / 414, y: (screen.size.height * 10) / 736 , width: (screen.size.width * 85) / 414, height: (screen.size.height * 85) / 736)
            historyScroll.addSubview(tabbLogo)
            
            let tabbNotHistory = UITextView()
            tabbNotHistory.frame = CGRect(x: (screen.size.width * 76) / 414, y: (screen.size.height * 115) / 736 , width: (screen.size.width * 240) / 414, height: (screen.size.height * 85) / 736)
            tabbNotHistory.text = "There is no use history this month."
            tabbNotHistory.backgroundColor = UIColor.clearColor()
            tabbNotHistory.editable = false
            tabbNotHistory.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            tabbNotHistory.textColor = UIColorFromHex(0x999999, alpha: 1.0)
            tabbNotHistory.textAlignment = .Center
            historyScroll.addSubview(tabbNotHistory)
        }
    }
    
    func getHistory(sender : AnyObject) {
        
        let formatYear = NSDateFormatter()
        formatYear.dateFormat = "yyyy";
        
        let formatMonth = NSDateFormatter()
        formatMonth.dateFormat = "MM";
        
        if(sender.tag == 1) {
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: tempDate, options: [])
            tempDate = date!
        } else {
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 1, toDate: tempDate, options: [])
            tempDate = date!
        }
        
        searchYear = Int.init(formatYear.stringFromDate(tempDate))!
        searchMonth = Int.init(formatMonth.stringFromDate(tempDate))!
        
        let url: String = serverURL + "user/bill/list"
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
    
    func getHistoryDetailView(sender : AnyObject) {
        
        let billId = (historyData.objectForKey("items") as! NSArray)[sender.tag].objectForKey("billId") as! Double
        
        let url: String = serverURL + "user/bill/view"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "billId" : billId]
        
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
                            
                            historyDetailData = post["data"] as! NSDictionary
                            
                            print(historyDetailData.objectForKey("checkInTime"))
                            dispatch_async(dispatch_get_main_queue(), {
                                self.historyDetailPop = HistoryDetailPopUp(nibName: "PopupView", bundle: nil)
                                self.historyDetailPop.showInView(self.view, withMessage: "History Detail", animated: true)
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

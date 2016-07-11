//
//  SplitPopUpController.swift
//  tabb
//
//  Created by LeeDongMin on 12/2/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class SplitPopUpController: UIViewController {

    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
    var confirm = UIButton()
    var close = UIButton()
    var line = UIView()
    
    var peopleProfileImage : Array<UIImageView> = []
    var peopleCheckList : Array<UIImageView> = []
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.85)

    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool) {
        peopleProfileImage = []
        peopleCheckList = []

        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        self.popUp = UIView()
        let screen: CGRect = UIScreen.mainScreen().bounds
        self.popUp.layer.shadowOpacity = 0.8
        self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.popUp.backgroundColor = UIColor.clearColor()
        self.popUp.frame = CGRectMake(0, 0,  menuWrapperBounds.width, menuWrapperBounds.height)
        
        popUpScrollView = UIScrollView()
        popUpScrollView.backgroundColor = UIColor.clearColor()
        popUpScrollView.frame = CGRectMake(0, (screen.size.height * 129) / 736, screen.size.width, (screen.size.height * 478) / 736)
        self.popUp.addSubview(popUpScrollView)
        
        let topImage = UIImageView(image: UIImage(named: "pop_top"))
        topImage.frame = CGRectMake((screen.size.width * 47) / 414, 0, (screen.size.width * 320) / 414, (screen.size.height * 124) / 736)
        popUpScrollView.addSubview(topImage)
        
        contentView = UIView()
        contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 124) / 736, (screen.size.width * 320) / 414, (screen.size.height * 300) / 736)
        contentView.backgroundColor = UIColor.whiteColor()
        popUpScrollView.addSubview(contentView)
        
        let splitImage = UIImageView(image: UIImage(named: "icon_pop1"))
        splitImage.frame = CGRectMake((screen.size.width * 142.5) / 414, 0, (screen.size.width * 35) / 414, (screen.size.height * 35) / 736)
        contentView.addSubview(splitImage)
        
        let splitTitle = UILabel()
        splitTitle.frame = CGRectMake((screen.size.width * 70) / 414, (screen.size.height * 46) / 736, (screen.size.width * 180) / 414, (screen.size.height * 20) / 736)
        splitTitle.text = paymentItems[tagNum].objectForKey("foodName") as? String
        splitTitle.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        splitTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        splitTitle.textAlignment = .Center
        contentView.addSubview(splitTitle)
        
        let splitPrice = UILabel()
        splitPrice.frame = CGRectMake((screen.size.width * 70) / 414, (screen.size.height * 70) / 736, (screen.size.width * 180) / 414, (screen.size.height * 20) / 736)
        splitPrice.text = (paymentItems[tagNum].objectForKey("amount") as! Double).format(someDoubleFormat) + " KD"
        splitPrice.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        splitPrice.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        splitPrice.textAlignment = .Center
        contentView.addSubview(splitPrice)
        
        let splitScript = UILabel()
        splitScript.frame = CGRectMake((screen.size.width * 20) / 414, (screen.size.height * 95) / 736, (screen.size.width * 280) / 414, (screen.size.height * 40) / 736)
        splitScript.numberOfLines = 0
        splitScript.text = "Please click the person(s)\nyou wish to split the bill of this dish with."
        splitScript.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        splitScript.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
        splitScript.textAlignment = .Center
        contentView.addSubview(splitScript)

        confirm = UIButton()
        close = UIButton()
        
        close.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 424) / 736, (screen.size.width * 160) / 414, (screen.size.height * 54) / 736)
        close.setTitle("CANCEL", forState: UIControlState.Normal)
        close.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        close.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        close.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        close.clipsToBounds = true
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(close)
        
        confirm.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 424) / 736, (screen.size.width * 160) / 414, (screen.size.height * 54) / 736)
        confirm.setTitle("SPLIT", forState: UIControlState.Normal)
        confirm.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        confirm.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        confirm.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.5)), forState: .Highlighted)
        confirm.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
        confirm.clipsToBounds = true
        confirm.addTarget(self, action: "sendSplit:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(confirm)
        
        line = UIView()
        line.frame = CGRectMake((screen.size.width * 206) / 414, (screen.size.height * 427) / 736, 1, (screen.size.height * 48) / 736)
        line.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        popUpScrollView.addSubview(line)
        
        self.view.addSubview(popUpScrollView)

        window.addSubview(self.view)

        //Split 가능한 인원 리스트
        self.listPeople()

        
        if animated
        {
            self.showAnimate()
        }
    }
    
    func listPeople() {
        
        toCheckIdIds.removeAllObjects()
        
        var count : CGFloat = 0
        var viewHeightCount : CGFloat = 0
        let viewHeight = (screen.size.height * 77) / 736
        let viewSpace = (screen.size.height * 23) / 736
        for(var index = 0 ; index < members.count; index++) {
            
            arrayForBool.addObject(false)
            
            let splitPeopleView = UIView()
            splitPeopleView.frame.size = CGSize(width: (screen.size.width * 58) / 414, height: (screen.size.height * 77) / 736)
            splitPeopleView.frame.offsetInPlace(dx: (screen.size.width * 27) / 414 + ((screen.size.width * 58) / 414 * count) + ((screen.size.width * 11) / 414 * count), dy: (screen.size.height * 170) / 736 + (viewHeight * viewHeightCount) + (viewSpace * viewHeightCount))
            splitPeopleView.backgroundColor = UIColor.clearColor()
            contentView.addSubview(splitPeopleView)
            
            let splitPeopleImage = UIImageView()
            splitPeopleImage.frame = CGRectMake(0, 0, (screen.size.width * 58) / 414, (screen.size.height * 58) / 736)
            splitPeopleImage.layer.cornerRadius = splitPeopleImage.frame.size.width / 2
            splitPeopleImage.clipsToBounds = true
            splitPeopleView.addSubview(splitPeopleImage)
            
            peopleProfileImage.append(splitPeopleImage)
            
            if(index == 0) {
                splitPeopleImage.image = imageList[index] as? UIImage
            } else {
                splitPeopleImage.image = grayImageList[index] as? UIImage
            }
            
            let splitPeopleBtn = UIButton()
            splitPeopleBtn.frame = CGRectMake(0, 0, (screen.size.width * 58) / 414, (screen.size.height * 58) / 736)
            splitPeopleBtn.layer.cornerRadius = splitPeopleImage.frame.size.width / 2
            splitPeopleBtn.clipsToBounds = true
            splitPeopleBtn.backgroundColor = UIColor.clearColor()
            splitPeopleBtn.addTarget(self, action: "changeCheck:", forControlEvents: UIControlEvents.TouchUpInside)
            splitPeopleBtn.tag = index
            splitPeopleView.addSubview(splitPeopleBtn)
            
            let splitPeopleCheck = UIImageView(image: UIImage(named: "icon_check2"))
            splitPeopleCheck.frame = CGRectMake( (screen.size.width * 40) / 414, 0,  (screen.size.width * 18) / 414, (screen.size.height * 18) / 736)
            splitPeopleCheck.hidden = true
            splitPeopleView.addSubview(splitPeopleCheck)
            
            peopleCheckList.append(splitPeopleCheck)
            
            let splitPeopleName = UILabel()
            splitPeopleName.frame = CGRectMake(0, (screen.size.height * 58) / 736, (screen.size.width * 58) / 414, (screen.size.height * 19) / 736)
            splitPeopleName.text = (members[index].objectForKey("userName") as? String)!
            splitPeopleName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            splitPeopleName.font = UIFont(name: lato, size: (screen.size.width * 13) / 414)
            splitPeopleName.textAlignment = .Center
            splitPeopleName.adjustsFontSizeToFitWidth = true
            splitPeopleView.addSubview(splitPeopleName)

            ++count

            if(count % 4 == 0) {
                ++viewHeightCount
                count = 0
            }
        }
        
        contentView.frame = CGRectMake((screen.size.width * 47) / 414, (screen.size.height * 124) / 736, (screen.size.width * 320) / 414, (screen.size.height * 300) / 736 + (viewHeight * viewHeightCount) + (viewSpace * viewHeightCount))
        
        
        let button_y = (contentView.frame.height + contentView.frame.origin.y)
        
        close.frame = CGRectMake((screen.size.width * 47) / 414, button_y, (screen.size.width * 160) / 414, (screen.size.height * 54) / 736)
        confirm.frame = CGRectMake((screen.size.width * 207) / 414, button_y, (screen.size.width * 160) / 414, (screen.size.height * 54) / 736)
        line.frame = CGRectMake((screen.size.width * 206) / 414, button_y + (screen.size.height * 3) / 736, 1, (screen.size.height * 48) / 736)
        
        let popUpHeight = button_y + (screen.size.height * 54) / 736
        
        if(popUpHeight > screen.size.height) {
            popUpScrollView.frame = CGRectMake(0, 0, screen.size.width, screen.size.height)
            popUpScrollView.contentSize = CGSize(width: contentView.frame.width, height: popUpHeight)
        } else {
            popUpScrollView.frame = CGRectMake(0, (screen.size.height - popUpHeight) / 2, screen.size.width, popUpHeight)
            popUpScrollView.contentSize = CGSize(width: contentView.frame.width, height: popUpHeight)
        }
        
        let check = peopleCheckList[0]
        check.hidden = false
        arrayForBool.replaceObjectAtIndex(0, withObject: true)
        toCheckIdIds.addObject(members[0].objectForKey("checkinId") as! Double)
        
    }
    
    func changeCheck(sender: AnyObject?) {
        
        if(sender!.tag == 0) {
            return;
        }
        
        if(arrayForBool.objectAtIndex((sender?.tag)!).boolValue == true) {
            let check = peopleCheckList[(sender?.tag)!]
            check.hidden = true
            arrayForBool.replaceObjectAtIndex((sender?.tag)!, withObject: false)
            toCheckIdIds.removeObject(members[(sender?.tag)!].objectForKey("checkinId") as! Double)
            peopleProfileImage[(sender?.tag)!].image = grayImageList[(sender?.tag)!] as? UIImage
        } else {
            let check = peopleCheckList[(sender?.tag)!]
            check.hidden = false
            arrayForBool.replaceObjectAtIndex((sender?.tag)!, withObject: true)
            toCheckIdIds.addObject(members[(sender?.tag)!].objectForKey("checkinId") as! Double)
            peopleProfileImage[(sender?.tag)!].image = imageList[(sender?.tag)!] as? UIImage
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
    
    func sendSplit(sender: AnyObject?) {
        
        if(toCheckIdIds.count == 1) {
            return;
        }
        
        let url: String = serverURL + "user/shareRequest/split"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId, "checkItemId" : checkItemId, "toCheckInIds" : toCheckIdIds]
        
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
                                self.removeAnimate()
                                splitAttemptChk = true
                                if(payment != nil) {
                                    payment.changeLoadings()
                                }

                            })
                            
                        } else if(status == 506){
                            //Have pay bill
                            //음식에 대해 스플릿을 진행하려 할때, 이미 결제를 진행한 사람을 선택했다면 스플릿이 진행되지 않아야 한다.
                            customPop.showInView(self.view, withMessage: "There are people already in progress payments. Please select again.", animated: true)

                        } else if(status == 609){
                            customPop.showInView(self.view, withMessage: "Targets cannot be a requestor alone.", animated: true)
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            customPop.showInView(self.view, withMessage: "Failed to split.", animated: true)
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
    }

}

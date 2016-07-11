//
//  ResultPayReviewController.swift
//  tabb
//
//  Created by LeeDongMin on 12/22/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class ResultPayReviewController: UIViewController, FloatRatingViewDelegate {

    var message = UILabel()
    var popUp = UIView()
    
    var popUpScrollView = UIScrollView()

    var evaluationList : NSMutableArray = NSMutableArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x222222, alpha: 0.85)

    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool) {
        
        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        self.popUp = UIView()
        
        self.popUp.layer.shadowOpacity = 0.8
        self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.popUp.backgroundColor = UIColor.clearColor()
        self.popUp.frame = CGRectMake(0, 0,  menuWrapperBounds.width, menuWrapperBounds.height)
        
        popUpScrollView = UIScrollView()
        popUpScrollView.backgroundColor = UIColor.clearColor()
        popUpScrollView.frame = CGRectMake(0, (screen.size.height * 0) / 736, screen.size.width, (screen.size.height * 736) / 736)
        self.popUp.addSubview(popUpScrollView)
        
        let reviewFoodBack = UIView()
        reviewFoodBack.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736, (screen.size.width * 392) / 414, (screen.size.height * 400) / 736)
        reviewFoodBack.backgroundColor = UIColor.whiteColor()
        popUpScrollView.addSubview(reviewFoodBack)
        
        let resultTitle = UILabel()
        resultTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 20) / 736, (screen.size.width * 360) / 414, (screen.size.height * 20) / 736)
        resultTitle.text = "Please evaluate the food."
        resultTitle.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        resultTitle.font = UIFont(name: latoBold, size: (screen.size.width * 18) / 414)
        //resultTitle.textAlignment = .Left
        reviewFoodBack.addSubview(resultTitle)
        
        let close = UIButton()
        close.frame = CGRectMake((screen.size.width * 354) / 414, (screen.size.height * 17) / 736, (screen.size.width * 27) / 414, (screen.size.height * 27) / 736)
        close.setBackgroundImage(UIImage(named: "btn_x2"), forState: .Normal)
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        reviewFoodBack.addSubview(close)
        
        //var totalHeightCount = 0
        var foodHeightCount : CGFloat = 0
        let line1ImageHeight = (screen.size.height * 2) / 736
        let foodBackHeight : CGFloat = (screen.size.height * 48) / 736
        
        for(var foodIndex = 0; foodIndex < evaluateFoodsItems.count; foodIndex++) {
            
            let line1 = UIView()
            line1.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
            line1.frame = CGRectMake(0, ((screen.size.height * 61) / 736) + (foodBackHeight * foodHeightCount), (screen.size.width * 392) / 414, line1ImageHeight)
            reviewFoodBack.addSubview(line1)
            
            let foodBack = UIView()
            foodBack.frame = CGRectMake(0, (screen.size.height * 61) / 736 + (foodBackHeight * foodHeightCount), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
            //foodBack.backgroundColor = UIColor.blueColor()
            reviewFoodBack.addSubview(foodBack)
            
            let foodName = UILabel()
            foodName.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 160) / 414, (screen.size.height * 20) / 736)
            foodName.text = evaluateFoodsItems[foodIndex].objectForKey("description") as? String
            foodName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            foodName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            //foodName.textAlignment = .Left
            foodBack.addSubview(foodName)
            
            //별점주기
            let foodRatingView = FloatRatingView()
            // Required float rating view params
            foodRatingView.emptyImage = UIImage(named: "btn_star_off")
            foodRatingView.fullImage = UIImage(named: "btn_star_on")
            // Optional params
            foodRatingView.delegate = self
            foodRatingView.contentMode = UIViewContentMode.ScaleAspectFit
            foodRatingView.maxRating = 5
            foodRatingView.minRating = 0
            foodRatingView.rating = (evaluateFoodsItems[foodIndex].objectForKey("grade") as? Float)!
            foodRatingView.editable = true
            foodRatingView.halfRatings = true
            foodRatingView.floatRatings = false
            foodRatingView.evaluationId = (evaluateFoodsItems[foodIndex].objectForKey("evaluationId") as? Double)!
            foodRatingView.frame = CGRectMake((screen.size.width * 226) / 414, (screen.size.height * 7.5) / 736, (screen.size.width * 155) / 414, (screen.size.height * 31) / 736)
            foodBack.addSubview(foodRatingView)
            
            
            
            ++foodHeightCount
            //++foodHeightCount
        }
        
        reviewFoodBack.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736 + (foodBackHeight * foodHeightCount))
        
        
        let reviewListBack = UIView()
        reviewListBack.frame = CGRectMake((screen.size.width * 11) / 414, reviewFoodBack.frame.size.height + reviewFoodBack.frame.origin.y + (screen.size.height * 11) / 736, (screen.size.width * 392) / 414, (screen.size.height * 242) / 736)
        reviewListBack.backgroundColor = UIColor.whiteColor()
        popUpScrollView.addSubview(reviewListBack)
        
        
        let listTitle = UILabel()
        listTitle.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 20) / 736, (screen.size.width * 250) / 414, (screen.size.height * 20) / 736)
        listTitle.text = "Please evaluate our service."
        listTitle.textColor = UIColorFromHex(0xc13939, alpha: 1.0)
        listTitle.font = UIFont(name: latoBold, size: (screen.size.width * 18) / 414)
        //resultTitle.textAlignment = .Left
        reviewListBack.addSubview(listTitle)

        //var totalHeightCount = 0
        var listHeightCount : CGFloat = 0
        let line2ImageHeight = (screen.size.height * 2) / 736
        let listBackHeight : CGFloat = (screen.size.height * 48) / 736
        
        for(var resIndex = 0; resIndex < evaluateRestaurantItems.count; resIndex++) {
            
            let line1 = UIView()
            line1.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
            line1.frame = CGRectMake(0, ((screen.size.height * 61) / 736) + (listBackHeight * listHeightCount), (screen.size.width * 392) / 414, line2ImageHeight)
            reviewListBack.addSubview(line1)
            
            let restaurantBack = UIView()
            restaurantBack.frame = CGRectMake(0, (screen.size.height * 61) / 736 + (listBackHeight * listHeightCount), (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
            //foodBack.backgroundColor = UIColor.blueColor()
            reviewListBack.addSubview(restaurantBack)
            
            let restaurantName = UILabel()
            restaurantName.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 13) / 736, (screen.size.width * 160) / 414, (screen.size.height * 20) / 736)
            restaurantName.text = evaluateRestaurantItems[resIndex].objectForKey("description") as? String
            restaurantName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
            restaurantName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
            //foodName.textAlignment = .Left
            restaurantBack.addSubview(restaurantName)
            
            //별점주기
            let restaurantRatingView = FloatRatingView()
            // Required float rating view params
            restaurantRatingView.emptyImage = UIImage(named: "btn_star_off")
            restaurantRatingView.fullImage = UIImage(named: "btn_star_on")
            // Optional params
            restaurantRatingView.delegate = self
            restaurantRatingView.contentMode = UIViewContentMode.ScaleAspectFit
            restaurantRatingView.maxRating = 5
            restaurantRatingView.minRating = 0
            restaurantRatingView.rating = (evaluateRestaurantItems[resIndex].objectForKey("grade") as? Float)!
            restaurantRatingView.editable = true
            restaurantRatingView.halfRatings = true
            restaurantRatingView.floatRatings = false
            restaurantRatingView.evaluationId = (evaluateRestaurantItems[resIndex].objectForKey("evaluationId") as? Double)!
            restaurantRatingView.frame = CGRectMake((screen.size.width * 226) / 414, (screen.size.height * 7.5) / 736, (screen.size.width * 155) / 414, (screen.size.height * 31) / 736)
            restaurantBack.addSubview(restaurantRatingView)
            
            
            
            ++listHeightCount
            //++foodHeightCount
        }
        
        reviewListBack.frame = CGRectMake((screen.size.width * 11) / 414, reviewFoodBack.frame.size.height + reviewFoodBack.frame.origin.y + (screen.size.height * 11) / 736, (screen.size.width * 392) / 414, (screen.size.height * 61) / 736 + (listBackHeight * listHeightCount))
        
        
        let skip: UIButton = UIButton()
        let send: UIButton = UIButton()
        
        skip.frame = CGRectMake((screen.size.width * 11) / 414, reviewListBack.frame.origin.y + reviewListBack.frame.size.height, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        skip.setTitle("SKIP", forState: UIControlState.Normal)
        skip.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        skip.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        skip.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        skip.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        skip.clipsToBounds = true
        skip.addTarget(self, action: "skipAction:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(skip)
        
        send.frame = CGRectMake((screen.size.width * 207) / 414, reviewListBack.frame.origin.y + reviewListBack.frame.size.height, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        send.setTitle("OK", forState: UIControlState.Normal)
        send.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        send.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        send.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        send.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
        send.clipsToBounds = true
        send.addTarget(self, action: "sendEvaluate:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(send)
        
        let btnLine = UIView()
        btnLine.frame = CGRectMake((screen.size.width * 207) / 414, reviewListBack.frame.origin.y + reviewListBack.frame.size.height + (screen.size.height * 3) / 736, 1, (screen.size.height * 48) / 736)
        btnLine.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        popUpScrollView.addSubview(btnLine)
        
        //scroll content size
        let resultPopHeight = skip.frame.origin.y + (screen.size.height * 54) / 736
        popUpScrollView.contentSize = CGSize(width: screen.size.width, height: resultPopHeight)
        
        self.view.addSubview(self.popUp)
        
        window.addSubview(self.view)
        
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.15, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.15, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func close(sender: AnyObject?) {
        
        self.removeAnimate()
        
        if(paymentChk == true) {
            paymentChk = false
            historyGoChk = true
            paymentDetail.backPressed(sender)
        }
    }
    
    func skipAction(sender: AnyObject) {
        self.removeAnimate()
        
        if(paymentChk == true) {
            paymentChk = false
            historyGoChk = true
            paymentDetail.backPressed(sender)

        }
    }
    
    func sendEvaluate(sender: AnyObject) {
        print(evaluationList)
        let url: String = serverURL + "user/evaluation/apply"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "evaluationList": evaluationList]
        
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
                                
                                if(paymentChk == true) {
                                    paymentChk = false
                                    historyGoChk = true
                                    paymentDetail.backPressed(sender)
//                                    let window = UIApplication.sharedApplication().windows[0]
//                                    let tab : UITabBarController = window.rootViewController as! UITabBarController
//                                    tab.selectedIndex = 3
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
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        
       // print(ratingView.rating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //print(ratingView.rating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float, evaluationId: Double) {
        print("evaluationId : \(evaluationId), rating : \(ratingView.rating)")
        let evaluationItem : NSMutableDictionary = NSMutableDictionary()
        evaluationItem.setValue(evaluationId, forKey: "evaluationId")
        evaluationItem.setValue(ratingView.rating, forKey: "grade")
        
        evaluationList.addObject(evaluationItem)
    }

}

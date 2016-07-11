//
//  SendFoodReviewPopUp.swift
//  tabb
//
//  Created by LeeDongMin on 12/7/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class SendFoodReviewPopUp: UIViewController, UITextFieldDelegate, FloatRatingViewDelegate, UITextViewDelegate {
    
    var message = UILabel()
    var popUp = UIView()
    var reviewContent = UITextView()
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var grade : Float = 0
    
    var reviewStar1 : UIImageView!
    var reviewStar2 : UIImageView!
    var reviewStar3 : UIImageView!
    var reviewStar4 : UIImageView!
    var reviewStar5 : UIImageView!
    
    var floatRatingView: FloatRatingView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x222222, alpha: 0.85)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func showInView(aView: UIView!, withMessage message: String!, animated: Bool) {

        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        self.popUp = UIView()

        self.popUp.layer.shadowOpacity = 0.8
        self.popUp.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.popUp.backgroundColor = UIColor.clearColor()
        self.popUp.frame = CGRectMake(0, 20,  menuWrapperBounds.width, menuWrapperBounds.height)
        
        let reviewBack = UIView()
        reviewBack.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 30) / 736, (screen.size.width * 392) / 414, (screen.size.height * 242) / 736)
        reviewBack.backgroundColor = UIColor.whiteColor()
        self.popUp.addSubview(reviewBack)
        
        let foodTitle = UILabel()
        foodTitle.frame = CGRectMake((screen.size.width * 36) / 414, (screen.size.height * 15) / 736, (screen.size.width * 320) / 414, (screen.size.height * 30) / 736)
        foodTitle.textAlignment = .Center
        foodTitle.text = foodReviewData.objectForKey("foodName") as? String
        foodTitle.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        foodTitle.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        foodTitle.numberOfLines = 1
        reviewBack.addSubview(foodTitle)
        
        let reviewLine = UIView()
        reviewLine.frame = CGRectMake(0, (screen.size.height * 61) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        reviewLine.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        reviewBack.addSubview(reviewLine)
        
        //별점주기
        floatRatingView = FloatRatingView()
        // Required float rating view params
        floatRatingView.emptyImage = UIImage(named: "btn_star_off2")
        floatRatingView.fullImage = UIImage(named: "btn_star_on2")
        // Optional params
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        floatRatingView.maxRating = 5
        floatRatingView.minRating = 0
        floatRatingView.rating = (foodReviewData.objectForKey("grade") as? Float)!
        floatRatingView.editable = true
        floatRatingView.halfRatings = true
        floatRatingView.floatRatings = false
        floatRatingView.frame = CGRectMake((screen.size.width * 118) / 414, (screen.size.height * 69) / 736, (screen.size.width * 155) / 414, (screen.size.height * 31) / 736)
        reviewBack.addSubview(floatRatingView)
        
        grade = foodReviewData.objectForKey("grade") as! Float

        
        let reviewLine1 = UIView()
        reviewLine1.frame = CGRectMake(0, (screen.size.height * 107) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        reviewLine1.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        reviewBack.addSubview(reviewLine1)
        
        reviewContent = UITextView()
        reviewContent.frame = CGRectMake((screen.size.width * 23) / 414, (screen.size.height * 120) / 736, (screen.size.width * 346) / 414, (screen.size.height * 134) / 736)
        reviewContent.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        reviewContent.backgroundColor = UIColor.clearColor()
        reviewContent.textColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        reviewContent.delegate = self
        reviewContent.text = "Please share your experience with other users."
        reviewBack.addSubview(reviewContent)
        
        
        let cancel: UIButton = UIButton()
        let post: UIButton = UIButton()
        
        cancel.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 242) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        cancel.setTitle("CANCEL", forState: UIControlState.Normal)
        cancel.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        cancel.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        cancel.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        cancel.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        cancel.clipsToBounds = true
        cancel.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(cancel)
        
        post.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 242) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        post.setTitle("POST", forState: UIControlState.Normal)
        post.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        post.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        post.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        post.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
        post.clipsToBounds = true
        post.addTarget(self, action: "postReview:", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUp.addSubview(post)
        
        let btnLine = UIView()
        btnLine.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 245) / 736, 1, (screen.size.height * 48) / 736)
        btnLine.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        self.popUp.addSubview(btnLine)
        
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.reviewContent.text = ""
        self.reviewContent.textColor = UIColorFromHex(0x666666, alpha: 1.0)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        print("handleSwipes")
        let tag = sender.view?.tag
        if (sender.direction == .Right)
        {
            // do your stuff
            print(tag)
        }
        else if (sender.direction == .Left)
        {
            // do your stuff
            print(tag)
        }
    }
    
    
    func myUIImageViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended){
            print("myUIImageView has been tapped by the user.")
        }
    }
    
    func close(sender: AnyObject?) {
        
        self.removeAnimate()
    }
    
    func postReview(sender: AnyObject?) {
        
        if(reviewContent.text! == "Please input food review") {
            reviewContent.text! = ""
        }
        
        let url: String = serverURL + "user/evaluation/applyPost"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkItemId": checkItemId, "grade" : grade, "comment" : reviewContent.text!]
        
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
    
    class MyTextField : UITextField {
        var leftTextMargin : CGFloat = 0.0
        var topTextMargin : CGFloat = 0.0
        
        override func textRectForBounds(bounds: CGRect) -> CGRect {
            var newBounds = bounds
            newBounds.origin.x += leftTextMargin
            newBounds.origin.y += topTextMargin
            return newBounds
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect {
            var newBounds = bounds
            newBounds.origin.x += leftTextMargin
            newBounds.origin.y += topTextMargin
            return newBounds
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if(showCheck == true) {
            return;
        }
        
        showCheck = true
        
        self.view.frame.origin.y -= 160
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        self.view.frame.origin.y += 160
    }
    
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        print(self.floatRatingView.rating)
        
        grade = self.floatRatingView.rating
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        print(self.floatRatingView.rating)
        
        grade = self.floatRatingView.rating
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float, evaluationId: Double) {
        
    }
    
}

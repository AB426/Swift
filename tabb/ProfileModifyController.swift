//
//  ProfileModifyController.swift
//  tabb
//
//  Created by LeeDongMin on 12/24/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfileModifyController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var modifyBack: UIView!
    
    var modifyScroll : UIScrollView!
    
    var modifyProfileImage : UIImageView!
    var userName : MyTextField!
    var birth : MyTextField!
    var gender : EdgeInsetLabel!
    internal var genderPlaceHolder : EdgeInsetLabel!
    var phoneNumber : MyTextField!
    internal var address : EdgeInsetLabel!
    internal var addressPlaceHolder : EdgeInsetLabel!
    
    var userEmail : UILabel!
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var changeProfileImage = false
    
    var addressPop : AddressInputPopUp = AddressInputPopUp(nibName: "PopupView", bundle: nil)
    
    var modifyGender : String = ""
    
    internal var addressChangeFlag = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileModify = self
        
        tempBitrhDay = ""
        
        modifyScroll = UIScrollView()
        modifyScroll.scrollEnabled = true
        modifyScroll.contentSize = self.view.frame.size
        modifyScroll.frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 736) / 736)
        modifyBack.addSubview(modifyScroll)

        modifyProfileImage = UIImageView()
        modifyProfileImage.frame = CGRectMake((screen.size.width * 161) / 414, (screen.size.height * 58) / 736, (screen.size.width * 92) / 414, (screen.size.height * 92) / 736)
        modifyProfileImage.layer.cornerRadius = modifyProfileImage.frame.width / 2
        modifyProfileImage.clipsToBounds = true
        modifyProfileImage.image = UIImage(named: "icon_nophoto")
        modifyScroll.addSubview(modifyProfileImage)
        
        modifyProfileImage.image = profileImage
        
        let profileBtn = UIButton()
        profileBtn.frame = CGRectMake((screen.size.width * 222) / 414, (screen.size.height * 112) / 736, (screen.size.width * 35) / 414, (screen.size.height * 35) / 736)
        profileBtn.setBackgroundImage(UIImage(named: "icon_add2"), forState: .Normal)
        profileBtn.addTarget(self, action: "btnImagePickerClicked:", forControlEvents: .TouchUpInside)
        modifyScroll.addSubview(profileBtn)
        
        userEmail = UILabel()
        userEmail.frame = CGRectMake((screen.size.width * 77) / 414, (screen.size.height * 155) / 736, (screen.size.width * 260) / 414, (screen.size.height * 30) / 736)
        userEmail.backgroundColor = UIColor.clearColor()
        userEmail.textAlignment = .Center
        userEmail.textColor = UIColor.whiteColor()
        if(pref.boolForKey("snsCheck")) {
            userEmail.text = ""
        } else {
            userEmail.text = pref.objectForKey("email") as? String
        }
        userEmail.font = UIFont(name: lato, size: (screen.size.width * 18) / 414)
        modifyScroll.addSubview(userEmail)
        
        let modifyTop = UIView()
        modifyTop.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 196) / 736, (screen.size.width * 392) / 414, (screen.size.height * 11) / 736)
        modifyTop.backgroundColor = UIColor.whiteColor()
        modifyTop.roundCorners(([.TopLeft, .TopRight]), radius: (screen.size.width * 3.5) / 414)
        modifyScroll.addSubview(modifyTop)
        
        userName = MyTextField()
        userName.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 207) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        userName.backgroundColor = UIColor.whiteColor()
        userName.textAlignment = .Left
        userName.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        userName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        userName.text = pref.objectForKey("userName") as? String
        userName.attributedPlaceholder = NSAttributedString(string:"UserName",
            attributes:[NSForegroundColorAttributeName: UIColorFromHex(0xcccccc, alpha: 1.0)])
        userName.delegate = self
        userName.leftTextMargin = 10
        modifyScroll.addSubview(userName)
        
        let line1 = UIView()
        line1.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 253) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line1.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        modifyScroll.addSubview(line1)

        
        birth = MyTextField()
        birth.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 254) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        birth.backgroundColor = UIColor.whiteColor()
        birth.textAlignment = .Left
        birth.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        birth.leftTextMargin = 10
        //birth.text = pref.objectForKey("birthDay") as? String
        
        birth.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        birth.attributedPlaceholder = NSAttributedString(string:"Date of birth(MMM. DD. YYYY)",
            attributes:[NSForegroundColorAttributeName: UIColorFromHex(0xcccccc, alpha: 1.0)])
        birth.addTarget(self, action: "dateField:", forControlEvents: .EditingDidBegin)
        birth.delegate = self
        modifyScroll.addSubview(birth)
        
        if profile.objectForKey("birthDay") is NSNull {
            //Null
        } else {
            let tempTime = profile.objectForKey("birthDay") as! Double
            let tempDate = NSDate(timeIntervalSince1970: tempTime / 1000)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "MMM. dd. yyyy";
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd, yyyy HH:mm:ss a";
            
            birthDay = formatter.stringFromDate(tempDate) // 수정해야될 생일 세팅
            
            birthDoubleValue = tempTime
            
            birth.text = timeFormatter.stringFromDate(tempDate)
        }

        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.BlackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "applyDate")
        ]
        
        numberToolbar.sizeToFit()
        
        birth.inputAccessoryView = numberToolbar
        
        let line2 = UIView()
        line2.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 300) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line2.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        modifyScroll.addSubview(line2)
        
        gender = EdgeInsetLabel()
        gender.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 301) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        gender.backgroundColor = UIColor.whiteColor()
        gender.textAlignment = .Left
        gender.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        genderPlaceHolder = EdgeInsetLabel()
        genderPlaceHolder.frame = CGRectMake(0, (screen.size.height * 10) / 736, (screen.size.width * 398) / 414, (screen.size.height * 26) / 736)
        genderPlaceHolder.text = "Gender"
        genderPlaceHolder.textColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        genderPlaceHolder.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        gender.addSubview(genderPlaceHolder)
        if profile.objectForKey("sex") is NSNull {
            //Null
            
            genderPlaceHolder.hidden = false
            
        } else {
            genderPlaceHolder.hidden = true
            
            if(profile.objectForKey("sex") as! String == "FEMALE") {
                gender.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                gender.text = "Female"
            } else {
                gender.textColor = UIColorFromHex(0x666666, alpha: 1.0)
                gender.text = "Male"
            }
            
            modifyGender = profile.objectForKey("sex") as! String
        }
        gender.userInteractionEnabled = true
        gender.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        modifyScroll.addSubview(gender)
        
        
        
        let tapGender = UITapGestureRecognizer(target: self, action: "modifyGender:")
        tapGender.numberOfTapsRequired = 1
        gender.addGestureRecognizer(tapGender)
        
        let line3 = UIView()
        line3.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 347) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line3.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        modifyScroll.addSubview(line3)
        
        phoneNumber = MyTextField()
        phoneNumber.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 348) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        phoneNumber.backgroundColor = UIColor.whiteColor()
        phoneNumber.textAlignment = .Left
        phoneNumber.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        phoneNumber.leftTextMargin = 10
        phoneNumber.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        phoneNumber.attributedPlaceholder = NSAttributedString(string:"Phone number",
            attributes:[NSForegroundColorAttributeName: UIColorFromHex(0xcccccc, alpha: 1.0)])
        modifyScroll.addSubview(phoneNumber)
        
        if profile.objectForKey("phone") is NSNull {
            //Null
        } else {
            phoneNumber.text = profile.objectForKey("phone") as? String
        }

        let line4 = UIView()
        line4.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 394) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line4.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        modifyScroll.addSubview(line4)
        
        address = EdgeInsetLabel()
        address.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 395) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address.backgroundColor = UIColor.whiteColor()
        address.textAlignment = .Left
        address.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address.adjustsFontSizeToFitWidth = true
        address.userInteractionEnabled = true
        address.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        modifyScroll.addSubview(address)
        
        addressPlaceHolder = EdgeInsetLabel()
        addressPlaceHolder.frame = CGRectMake(0, (screen.size.height * 10) / 736, (screen.size.width * 398) / 414, (screen.size.height * 26) / 736)
        addressPlaceHolder.text = "Address"
        addressPlaceHolder.textColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        addressPlaceHolder.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        address.addSubview(addressPlaceHolder)
        
        let tempAddress = profile.objectForKey("address") as! String
        if(tempAddress != "") {
            addressPlaceHolder.hidden = true
            address.text = tempAddress
            addressChangeFlag = true
        }

        let tapAddress = UITapGestureRecognizer(target: self, action: "modifyAddress:")
        tapAddress.numberOfTapsRequired = 1
        address.addGestureRecognizer(tapAddress)
        
        
        let cancel: UIButton = UIButton()
        let save: UIButton = UIButton()
        
        cancel.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 441) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        cancel.setTitle("CANCEL", forState: UIControlState.Normal)
        cancel.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        cancel.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        cancel.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        cancel.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        cancel.clipsToBounds = true
        cancel.addTarget(self, action: "backPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        modifyScroll.addSubview(cancel)
        
        save.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 441) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        save.setTitle("SAVE", forState: UIControlState.Normal)
        save.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        save.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        save.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        save.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
        save.clipsToBounds = true
        save.addTarget(self, action: "sendModifyProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        modifyScroll.addSubview(save)
        
        let btnLine = UIView()
        btnLine.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 444) / 736, (screen.size.width * 1) / 414, (screen.size.height * 48) / 736)
        btnLine.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        modifyScroll.addSubview(btnLine)
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        modifyScroll.addSubview(callView)
        
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
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        
    }

    @IBAction func backPressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func btnImagePickerClicked(sender: AnyObject) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCameraButton()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.selectPicture()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        profileImage = imageResize(newImage, sizeChange: CGSize(width: (screen.size.width * 150) / 414, height: (screen.size.height * 150) / 736))
        
        modifyProfileImage.image = profileImage
        modifyProfileImage.layer.cornerRadius = modifyProfileImage.frame.width / 2
        modifyProfileImage.clipsToBounds = true
        
        changeProfileImage = true

        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancel () {
        self.birth.text=""
        self.birth.resignFirstResponder()
    }
    
    func applyDate () {
        
        if(tempBitrhDay == "") {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "MMM. dd. yyyy";
            
            birth.text = timeFormatter.stringFromDate(NSDate())
            
            birthDoubleValue = NSDate().timeIntervalSince1970 * 1000
            
        } else {
            birth.text = tempBitrhDay
        }
        self.birth.resignFirstResponder()
        
        tempBitrhDay = ""
    }
    
    func dateField(sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func DoneButton(sender: UIButton) {
        birth.resignFirstResponder()
        //How to make datepicker disappear???
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "MMM. dd. yyyy";
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy HH:mm:ss a";
        
        birthDay = formatter.stringFromDate(sender.date)
        
        birthDoubleValue = sender.date.timeIntervalSince1970 * 1000
        
        tempBitrhDay = timeFormatter.stringFromDate(sender.date)
    }
    
    func modifyGender(recognizer: UITapGestureRecognizer){
        let alert:UIAlertController=UIAlertController(title: "Choose Gender", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let maleAction = UIAlertAction(title: "Male", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.modifyGender = "MALE"
            self.gender.text = "Male"
            self.genderPlaceHolder.hidden = true
            self.gender.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        }
        let femaleAction = UIAlertAction(title: "Female", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.modifyGender = "FEMALE"
            self.gender.text = "Female"
            self.genderPlaceHolder.hidden = true
            self.gender.textColor = UIColorFromHex(0x666666, alpha: 1.0)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.gender.text = ""
            self.genderPlaceHolder.text = "Gender"
            self.genderPlaceHolder.hidden = false
            self.gender.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        }
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func modifyAddress(recognizer: UITapGestureRecognizer){
        //팝업창
        addressPop = AddressInputPopUp(nibName: "PopupView", bundle: nil)
        addressPop.showInView(self.view, withMessage: "Address Input", animated: true)
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
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {

            self.modifyScroll.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            self.modifyScroll.contentOffset.y += keyboardSize.size.height
            
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        //self.view.frame.origin.y += 160
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {

            self.modifyScroll.contentOffset.y -= keyboardSize.size.height
            self.modifyScroll.contentInset = UIEdgeInsetsMake(0, 0, -keyboardSize.height, 0)
        }
        
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    class EdgeInsetLabel : UILabel {
        var edgeInsets:UIEdgeInsets = UIEdgeInsetsZero
        
        override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
            var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
            
            rect.origin.x -= edgeInsets.left
            rect.origin.y -= edgeInsets.top
            rect.size.width  += (edgeInsets.left + edgeInsets.right);
            rect.size.height += (edgeInsets.top + edgeInsets.bottom);
            
            return rect
        }
        
        override func drawTextInRect(rect: CGRect) {
            super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
        }
    }
    
    func sendModifyProfile(sender : AnyObject?) {

        if(self.userName.text == "") {
            customPop.showInView(self.view, withMessage: "please input your name.", animated: true)
            return;
        }
        
        if(self.birth.text == "") {
            customPop.showInView(self.view, withMessage: "Please select your birthday.", animated: true)
            return;
        }
        
        if(self.gender.text == "") {
            customPop.showInView(self.view, withMessage: "Please select your gender.", animated: true)
            return;
        }
        
        if(self.phoneNumber.text == "") {
            customPop.showInView(self.view, withMessage: "Please input your phone number", animated: true)
            return;
        }
        
        if(!addressChangeFlag) {
            customPop.showInView(self.view, withMessage: "Please input address.", animated: true)
            return;
        }

        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let snsCheck = pref.objectForKey("snsCheck") as! Bool
        var authType : String!
        if(snsCheck) {
            authType = "FACEBOOK"
        } else {
            authType = "EMAIL"
        }
        
        var request : NSMutableURLRequest!

        let url: String = serverURL + "user/profile/modify"
        
        request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let newPost: NSDictionary = ["authId" : authId, "authKey" : authKey, "address" : address.text!, "name" : userName.text!, "sex" : modifyGender, "birthDay" : birthDoubleValue, "phone" : phoneNumber.text!, "authType" : authType]
        
        print("tabb modify \(newPost)")
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
                                // code here
                                if(self.changeProfileImage) {
                                    self.sendModifyProfileImage()
                                } else {
                                    profileChangeCheck = true
                                    customPop.showInView(self.view, withMessage: "Edit your profile is complete.", animated: true)
                                }
                                
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                let windowView = UIApplication.sharedApplication().keyWindow!
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: "This profile is not modified. Please try again later.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let windowView = UIApplication.sharedApplication().keyWindow!
                            hideActivityIndicator(windowView)
                            
                            //customPop.showInView(self.view, withMessage: "A check of the server. Please try again later.", animated: true)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let windowView = UIApplication.sharedApplication().keyWindow!
                        hideActivityIndicator(windowView)
                        
                        customPop.showInView(self.view, withMessage: "A check of the server. Please try again later.", animated: true)
                    })
                    
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    let windowView = UIApplication.sharedApplication().keyWindow!
                    hideActivityIndicator(windowView)
                    
                    customPop.showInView(self.view, withMessage: "A check of the server. Please try again later.", animated: true)
                })
                
                return
            }
        }
        task.resume()
    }
    
    func sendModifyProfileImage() {
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String

        var request : NSMutableURLRequest!
        
        var imageData : NSData = NSData()
        var fileName : String = ""
        if(changeProfileImage) {
            imageData = UIImageJPEGRepresentation(profileImage, 1)!
            fileName = "profile.jpg"
        }
        
        let url: String = serverURL + "profile/user/modifyUserImg"
        
        request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let boundary = self.generateBoundaryString()
        let fullData = photoDataToFormData(Int.init(authId), authKey: authKey, data: imageData, boundary:boundary, fileName:fileName)
        
        
        request.HTTPBody = fullData
        request.HTTPShouldHandleCookies = false
        
        request.HTTPMethod = "POST"
        request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        
        
        
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
                                // code here
                                profileChangeCheck = true
                                customPop.showInView(self.view, withMessage: "Edit your profile is complete.", animated: true)
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                
                                let windowView = UIApplication.sharedApplication().keyWindow!
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: "A check of the server. Please try again later.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let windowView = UIApplication.sharedApplication().keyWindow!
                            hideActivityIndicator(windowView)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let windowView = UIApplication.sharedApplication().keyWindow!
                        hideActivityIndicator(windowView)
                    })
                    
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    let windowView = UIApplication.sharedApplication().keyWindow!
                    hideActivityIndicator(windowView)
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
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(authId: Int, authKey: String, data:NSData, boundary:String, fileName:String) -> NSData {
        let fullData = NSMutableData()
        
        // 0 - Boundary should start with --
        let lineZero = "--" + boundary + "\r\n"
        fullData.appendData(lineZero.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        fullData.appendData(("Content-Disposition: form-data; name=\"authId\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        fullData.appendData(("\(authId)\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        
        // 0_1 - Boundary should start with --
        let lineZero_1 = "--" + boundary + "\r\n"
        fullData.appendData(lineZero_1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        fullData.appendData(("Content-Disposition: form-data; name=\"authKey\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        fullData.appendData(("\(authKey)\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.appendData(lineOne.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        //if(fileName != "") {
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.appendData(lineTwo.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.appendData(lineThree.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 4
        fullData.appendData(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.appendData(lineFive.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        //}
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.appendData(lineSix.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        return fullData
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }

}

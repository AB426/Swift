//
//  JoinGenderController.swift
//  tabb
//
//  Created by LeeDongMin on 12/10/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class JoinGenderController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var genderBack: UIView!
    
    var maleImageView : UIImageView!
    var femaleImageView : UIImageView!
    var birth : UITextField!
    
    var genderText : String = ""
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maleView = UIView()
        maleView.frame = CGRectMake((screen.size.width * 111) / 414, (screen.size.height * 76) / 736, (screen.size.width * 73) / 414, (screen.size.height * 73) / 736)
        genderBack.addSubview(maleView)
        
        maleImageView = UIImageView(image: UIImage(named: "btn_gender"))
        maleImageView.frame = CGRectMake(0, 0, (screen.size.width * 73) / 414, (screen.size.height * 73) / 736)
        maleView.addSubview(maleImageView)
        let maleTitle = UILabel()
        maleTitle.frame = CGRectMake((screen.size.width * 6.5) / 414, (screen.size.height * 21.5) / 736, (screen.size.width * 60) / 414, (screen.size.height * 30) / 736)
        maleTitle.text = "MALE"
        maleTitle.textColor = UIColor.whiteColor()
        maleTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        maleTitle.textAlignment = .Center
        maleView.addSubview(maleTitle)
        let maleBtn = UIButton()
        maleBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 73 / 414), height: (screen.size.height * 73 / 736))
        maleBtn.backgroundColor = UIColor.clearColor()
        maleBtn.layer.cornerRadius = maleBtn.frame.size.width / 2
        maleBtn.addTarget(self, action: "changeGender:", forControlEvents: .TouchUpInside)
        maleBtn.tag = 1
        maleView.addSubview(maleBtn)
        
        let femaleView = UIView()
        femaleView.frame = CGRectMake((screen.size.width * 230) / 414, (screen.size.height * 76) / 736, (screen.size.width * 73) / 414, (screen.size.height * 73) / 736)
        genderBack.addSubview(femaleView)
        
        femaleImageView = UIImageView(image: UIImage(named: "btn_gender"))
        femaleImageView.frame = CGRectMake(0, 0, (screen.size.width * 73) / 414, (screen.size.height * 73) / 736)
        femaleView.addSubview(femaleImageView)
        let femaleTitle = UILabel()
        femaleTitle.frame = CGRectMake((screen.size.width * 6.5) / 414, (screen.size.height * 21.5) / 736, (screen.size.width * 60) / 414, (screen.size.height * 30) / 736)
        femaleTitle.text = "FEMALE"
        femaleTitle.textColor = UIColor.whiteColor()
        femaleTitle.font = UIFont(name: latoBold, size: (screen.size.width * 15) / 414)
        femaleTitle.textAlignment = .Center
        femaleView.addSubview(femaleTitle)
        let femaleBtn = UIButton()
        femaleBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 73 / 414), height: (screen.size.height * 73 / 736))
        femaleBtn.backgroundColor = UIColor.clearColor()
        femaleBtn.layer.cornerRadius = maleBtn.frame.size.width / 2
        femaleBtn.addTarget(self, action: "changeGender:", forControlEvents: .TouchUpInside)
        femaleBtn.tag = 2
        femaleView.addSubview(femaleBtn)
        
        birth = UITextField()
        birth.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 225) / 736, (screen.size.width * 392) / 414, (screen.size.height * 30) / 736)
        birth.backgroundColor = UIColor.clearColor()
        birth.textAlignment = .Center
        birth.textColor = UIColor.whiteColor()
        birth.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        birth.attributedPlaceholder = NSAttributedString(string:"Date of birth(MMM. DD. YYYY)",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        birth.addTarget(self, action: "dateField:", forControlEvents: .EditingDidBegin)
        genderBack.addSubview(birth)
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.BlackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "applyDate")
        ]
        
        numberToolbar.sizeToFit()
        
        birth.inputAccessoryView = numberToolbar
        
        let genderLine = UIView()
        genderLine.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 265) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        genderLine.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        genderBack.addSubview(genderLine)
        
        let nextView = UIView()
        nextView.frame = CGRect(x: (screen.size.width * 170 / 414), y: (screen.size.height * 520 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        nextView.layer.cornerRadius = nextView.frame.size.width / 2
        genderBack.addSubview(nextView)
        
        let nextImage = UIImageView(image: UIImage(named: "btn_next"))
        nextImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
        nextView.addSubview(nextImage)
        
        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextBtn.backgroundColor = UIColor.clearColor()
        nextBtn.layer.cornerRadius = nextBtn.frame.size.width / 2
        nextBtn.clipsToBounds = true
        nextBtn.addTarget(self, action: "nextAction:", forControlEvents: .TouchUpInside)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
        nextView.addSubview(nextBtn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
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
    
    func cancel () {
        self.birth.text=""
        self.birth.resignFirstResponder()
    }
    
    func applyDate () {
       
        if(tempBitrhDay == "") {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "MMM. dd. yyyy";
            
            birth.text = timeFormatter.stringFromDate(NSDate())
            
            birthDoubleValue = round((NSDate().timeIntervalSince1970 * 1000))
        } else {
            birth.text = tempBitrhDay
        }
        self.birth.resignFirstResponder()
        
        print("birthDoubleValue : \(birthDoubleValue)")
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
        
        print(sender.date.timeIntervalSince1970)
        
        birthDoubleValue = (sender.date.timeIntervalSince1970 * 1000)

        tempBitrhDay = timeFormatter.stringFromDate(sender.date)
    }
    
    func nextAction(sender: AnyObject?) {
        
        if(genderText == "") {
            customPop.showInView(self.view, withMessage: "성별을 선택하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        if(birth == "") {
            customPop.showInView(self.view, withMessage: "생년월일을 선택하여 주시기 바랍니다.", animated: true)
            return;
        }
        
        
        pref.setValue(genderText, forKey: "gender")
        
        if(birth.text == "") {
            pref.setValue(nil, forKey: "birthDay")
        } else {
            pref.setValue(birth.text, forKey: "birthDay")
        }
        
        tempBitrhDay = ""
        
        self.performSegueWithIdentifier("emailSegue", sender: sender)
    }
    
    func changeGender(sender: AnyObject?) {
        if(sender!.tag == 1) {
            maleImageView.image = UIImage(named: "btn_genderr")
            femaleImageView.image = UIImage(named: "btn_gender")
            genderText = "MALE"
        } else {
            maleImageView.image = UIImage(named: "btn_gender")
            femaleImageView.image = UIImage(named: "btn_genderr")
            genderText = "FEMALE"
        }
    }
    
    @IBAction func backPressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
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

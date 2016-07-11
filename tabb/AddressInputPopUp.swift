//
//  AddressInputPopUp.swift
//  tabb
//
//  Created by LeeDongMin on 12/31/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class AddressInputPopUp: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var message = UILabel()
    var popUp = UIView()
    var contentView = UIView()
    
    var popUpScrollView = UIScrollView()
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    var address1 : MyTextField!
    var address2 : MyTextField!
    var address3 : MyTextField!
    var address4 : MyTextField!
    var address5 : MyTextField!
    var address6 : MyTextField!
    
    var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    var selectArea : String = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Abdullah Al Salem","Adailiya","Bend Al Gar","Da0iya","Dasma","Dasman","Doha","Faiha","Granada","Jaber Al Ahmed","Kaifan","Khaldiya","Kuwait City","Mansouriya","Mirqab","Mubarakiya","Nahda","Nuzha","Qadsiya","Qibla","Qourtoba","Rawda","Salhiya","Shamiya","Sharq","Shuwaikh","Sulaibikhat","Surra","Yarmouk", "Al-Bidaa","Bayan","awally","Hateen","Jabriya","Maidan Hawally","Mishref","Mubarak Al Khabeer","Rumaithiya","Salam","Salmiya","Salwa","Shaab","Shuhada","Zahra","Abraq Khaitan","Airport","Andalous","Ardiya","Ashbeliah","Dhajeej","Farwaniya","Firdous","Jleeb Al Shuyouk","Khaitan","Omariya","Rabiya","Al Rai","Reggae","Rehab","Sabah Al Nasser","Sheikh Saad Al Abdullah Airport","Abu Halifa","Al Julaiya","Al Ahmadi","Ali Sabah Al Salem","Dhaher","East Al Ahmadi","Eqaila","Faced Al Ahmed","Fahaheel","Fintas","Hadiya","Jaber Al Ali","Khairan","Magwa","Mahboulah","Mangaf","Mina Al Abdullah","Mina Al Ahmadi","Nuwaiseeb","Riqqa","Sabah Al Ahmad Marine City","Sabah Al Ahmad Residential","Sabahiya","Shuaiba","Wafer Farns","Wafer Residential","Al Naeem","Amghara Industrial","Jahra","Kabd","Naseem","Oyoun","Qairawan-South Doha","Qasr","Saad Al Abdullah","Sulaibiya Industrial 1","Sulaibiya Industrial 2","Sulaibiya Residential","Sulaibiya","Taima","Waha","Abu Fatira","Abu Hassaniya","Adan","Al Masayel","Al Qurain","Al Qusour","Coast Strip B","Fnaitees","Messila","Mubarak Al Khabeer","Sabah Al Salem","Subhan","south Wista","West Abu Fatira Small Industrial","wista"]
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
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
        
        popUpScrollView = UIScrollView()
        popUpScrollView.backgroundColor = UIColor.clearColor()
        popUpScrollView.frame = CGRectMake(0, 0, menuWrapperBounds.width, menuWrapperBounds.height)
        popUpScrollView.contentSize = CGSize(width: menuWrapperBounds.width, height: menuWrapperBounds.height)
        self.popUp.addSubview(popUpScrollView)

        let modifyTop = UIView()
        modifyTop.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 11) / 736, (screen.size.width * 392) / 414, (screen.size.height * 11) / 736)
        modifyTop.backgroundColor = UIColor.whiteColor()
        modifyTop.roundCorners(([.TopLeft, .TopRight]), radius: (screen.size.width * 3.5) / 414)
        popUpScrollView.addSubview(modifyTop)
        
        
        address1 = MyTextField()
        address1.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 22) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address1.backgroundColor = UIColor.whiteColor()
        address1.textAlignment = .Center
        address1.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address1.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address1.placeholder = "AREA"
        address1.addTarget(self, action: "selectArea:", forControlEvents: .EditingDidBegin)
        address1.delegate = self
        popUpScrollView.addSubview(address1)

//        let tapAddress = UITapGestureRecognizer(target: self, action: "selectArea:")
//        tapAddress.numberOfTapsRequired = 1
//        address1.addGestureRecognizer(tapAddress)
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.BlackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "applyDate")
        ]
        
        numberToolbar.sizeToFit()
        
        address1.inputAccessoryView = numberToolbar
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        let line2 = UIView()
        line2.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 68) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line2.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        popUpScrollView.addSubview(line2)
        
        address2 = MyTextField()
        address2.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 69) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address2.backgroundColor = UIColor.whiteColor()
        address2.textAlignment = .Center
        address2.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address2.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address2.placeholder = "BLOCK"
        address2.keyboardType = UIKeyboardType.NumberPad
        popUpScrollView.addSubview(address2)
        
        let line3 = UIView()
        line3.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 115) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line3.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        popUpScrollView.addSubview(line3)

        address3 = MyTextField()
        address3.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 116) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address3.backgroundColor = UIColor.whiteColor()
        address3.textAlignment = .Center
        address3.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address3.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address3.placeholder = "STREET"
        address3.keyboardType = UIKeyboardType.NumberPad
        popUpScrollView.addSubview(address3)
        
        let line4 = UIView()
        line4.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 162) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line4.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        popUpScrollView.addSubview(line4)

        address4 = MyTextField()
        address4.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 163) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address4.backgroundColor = UIColor.whiteColor()
        address4.textAlignment = .Center
        address4.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address4.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address4.placeholder = "LANE"
        address4.keyboardType = UIKeyboardType.NumberPad
        popUpScrollView.addSubview(address4)
        
        let line5 = UIView()
        line5.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 209) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line5.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        popUpScrollView.addSubview(line5)
        
        address5 = MyTextField()
        address5.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 210) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address5.backgroundColor = UIColor.whiteColor()
        address5.textAlignment = .Center
        address5.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address5.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address5.placeholder = "HOUSE"
        address5.keyboardType = UIKeyboardType.NumberPad
        popUpScrollView.addSubview(address5)
        
        let line6 = UIView()
        line6.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 256) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        line6.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        popUpScrollView.addSubview(line6)
        
        address6 = MyTextField()
        address6.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 257) / 736, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        address6.backgroundColor = UIColor.whiteColor()
        address6.textAlignment = .Center
        address6.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        address6.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        address6.placeholder = "FLAT"
        address6.keyboardType = UIKeyboardType.NumberPad
        popUpScrollView.addSubview(address6)
        
        let numberToolbar1: UIToolbar = UIToolbar()
        numberToolbar1.barStyle = UIBarStyle.BlackTranslucent
        numberToolbar1.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "apply")
        ]
        
        numberToolbar1.sizeToFit()
        
        address2.inputAccessoryView = numberToolbar1
        address3.inputAccessoryView = numberToolbar1
        address4.inputAccessoryView = numberToolbar1
        address5.inputAccessoryView = numberToolbar1
        address6.inputAccessoryView = numberToolbar1
        
        if(modifyAddress1 != "") {
            address1.text = modifyAddress1
        }
        
        if(modifyAddress2 != "") {
            address2.text = modifyAddress2
        }
        
        if(modifyAddress3 != "") {
            address3.text = modifyAddress3
        }
        
        if(modifyAddress4 != "") {
            address4.text = modifyAddress4
        }
        
        if(modifyAddress5 != "") {
            address5.text = modifyAddress5
        }
        
        if(modifyAddress6 != "") {
            address6.text = modifyAddress6
        }
        
        
        let cancel: UIButton = UIButton()
        let save: UIButton = UIButton()
        
        cancel.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 303) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        cancel.setTitle("CANCEL", forState: UIControlState.Normal)
        cancel.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        cancel.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        cancel.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        cancel.roundCorners(([.BottomLeft]), radius: (screen.size.width * 3.5) / 414)
        cancel.clipsToBounds = true
        cancel.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(cancel)
        
        save.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 303) / 736, (screen.size.width * 196) / 414, (screen.size.height * 54) / 736)
        save.setTitle("SAVE", forState: UIControlState.Normal)
        save.setTitleColor(UIColorFromRGB(0xffffff), forState: UIControlState.Normal)
        save.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939")), forState: .Normal)
        save.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#c13939", alpha: 0.8)), forState: .Highlighted)
        save.roundCorners(([.BottomRight]), radius: (screen.size.width * 3.5) / 414)
        save.clipsToBounds = true
        save.addTarget(self, action: "saveAddress:", forControlEvents: UIControlEvents.TouchUpInside)
        popUpScrollView.addSubview(save)
        
        let btnLine = UIView()
        btnLine.frame = CGRectMake((screen.size.width * 207) / 414, (screen.size.height * 306) / 736, (screen.size.width * 1) / 414, (screen.size.height * 48) / 736)
        btnLine.backgroundColor = UIColorFromHex(0xd37575, alpha: 1.0)
        popUpScrollView.addSubview(btnLine)
        
        self.view.addSubview(self.popUp)
        
        aView.addSubview(self.view)
        
        //window.addSubview(self.view)
        
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
    
    func saveAddress(sender: AnyObject?) {
        
        if(self.address1.text! == "") {
            customPop.showInView(self.view, withMessage: "Please input AREA.", animated: true)
            return;
        }
        
        if(self.address2.text! == "") {
            customPop.showInView(self.view, withMessage: "Please input BLOCK No.", animated: true)
            return;
        }
        
        if(self.address3.text! == "") {
            customPop.showInView(self.view, withMessage: "Please input STREET No.", animated: true)
            return;
        }
        
        if(self.address5.text! == "") {
            customPop.showInView(self.view, withMessage: "Please input HOUSE No.", animated: true)
            return;
        }
        
        self.removeAnimate()
        
        profileModify.address.text = "House " + self.address5.text! + ". Street " + self.address3.text! + ". Block " + self.address2.text! + ". " + self.address1.text!

        if(self.address4.text! != "") {
            profileModify.address.text = "House " + self.address5.text! + ". Lane " + self.address4.text! + ". Street " + self.address3.text! + ". Block " + self.address2.text! + ". " + self.address1.text!
        }
        
        if(self.address6.text! != "") {
            profileModify.address.text = "Flat " + self.address6.text! + ". House " + self.address5.text! + ". Lane " + self.address4.text! + ". Street " + self.address3.text! + ". Block " + self.address2.text! + ". " + self.address1.text!
        }
        
        modifyAddress1 = self.address1.text!
        modifyAddress2 = self.address2.text!
        modifyAddress3 = self.address3.text!
        modifyAddress4 = self.address4.text!
        modifyAddress5 = self.address5.text!
        modifyAddress6 = self.address6.text!

        profileModify.address.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        profileModify.addressPlaceHolder.hidden = true
        profileModify.addressChangeFlag = true
        
    }
    
    func selectArea(sender: UITextField) {
        sender.inputView = picker
    }
    
    func cancel () {

        self.address1.resignFirstResponder()
    }
    
    func applyDate () {
        if(selectArea == "") {
            self.address1.text = pickerData[0]
        } else {
            self.address1.text = selectArea
        }
        
        self.address1.resignFirstResponder()
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        selectArea = pickerData[row]
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
            
            self.popUpScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            //self.popUpScrollView.contentOffset.y += keyboardSize.size.height
            
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        //self.view.frame.origin.y += 160
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            //self.popUpScrollView.contentOffset.y -= keyboardSize.size.height
            self.popUpScrollView.contentInset = UIEdgeInsetsMake(0, 0, -keyboardSize.height, 0)
        }
        
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func apply() {
        self.DismissKeyboard()
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
}

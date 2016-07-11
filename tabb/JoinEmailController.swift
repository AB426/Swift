//
//  JoinEmailController.swift
//  tabb
//
//  Created by LeeDongMin on 12/10/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class JoinEmailController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var joinEmailBack: UIView!
    
    var email : UITextField!
    var pass : UITextField!
    var confirmPass : UITextField!
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = UITextField()
        email.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 107) / 736, (screen.size.width * 392) / 414, (screen.size.height * 30) / 736)
        email.backgroundColor = UIColor.clearColor()
        email.textAlignment = .Center
        email.textColor = UIColor.whiteColor()
        email.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        email.attributedPlaceholder = NSAttributedString(string:"Enter your E-mail Address",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        email.delegate = self
        email.keyboardType = UIKeyboardType.EmailAddress
        joinEmailBack.addSubview(email)
        
        let passLine1 = UIView()
        passLine1.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 147) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        passLine1.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        joinEmailBack.addSubview(passLine1)

        pass = UITextField()
        pass.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 225) / 736, (screen.size.width * 392) / 414, (screen.size.height * 30) / 736)
        pass.backgroundColor = UIColor.clearColor()
        pass.textAlignment = .Center
        pass.textColor = UIColor.whiteColor()
        pass.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        pass.attributedPlaceholder = NSAttributedString(string:"Enter your Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        pass.delegate = self
        pass.secureTextEntry = true
        joinEmailBack.addSubview(pass)

        let passLine2 = UIView()
        passLine2.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        passLine2.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 265) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        joinEmailBack.addSubview(passLine2)
        
        confirmPass = UITextField()
        confirmPass.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 275) / 736, (screen.size.width * 392) / 414, (screen.size.height * 30) / 736)
        confirmPass.backgroundColor = UIColor.clearColor()
        confirmPass.textAlignment = .Center
        confirmPass.textColor = UIColor.whiteColor()
        confirmPass.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        confirmPass.attributedPlaceholder = NSAttributedString(string:"Confirm your Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        confirmPass.delegate = self
        confirmPass.secureTextEntry = true
        joinEmailBack.addSubview(confirmPass)
        
        let nextView = UIView()
        nextView.frame = CGRect(x: (screen.size.width * 170 / 414), y: (screen.size.height * 520 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        nextView.layer.cornerRadius = nextView.frame.size.width / 2
        joinEmailBack.addSubview(nextView)
        
        let nextImage = UIImageView(image: UIImage(named: "btn_next"))
        nextImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
        nextView.addSubview(nextImage)
        
        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextBtn.backgroundColor = UIColor.clearColor()
        nextBtn.layer.cornerRadius = nextBtn.frame.size.width / 2
        nextBtn.addTarget(self, action: "nextAction:", forControlEvents: .TouchUpInside)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
        nextBtn.clipsToBounds = true
        nextView.addSubview(nextBtn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.nextAction(nil)
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
    
    func nextAction(sender: AnyObject?) {
        
        if(!isValidEmail(email.text!)) {
            customPop.showInView(self.view, withMessage: "This e-mail address format is incorrect", animated: true)
            return;
        }
        
        if(pass.text == "") {
            customPop.showInView(self.view, withMessage: "Please enter a password", animated: true)
            return;
        }
        
        if(pass.text != confirmPass.text) {
            customPop.showInView(self.view, withMessage: "The password is different. Please check a password", animated: true)
            return;
        }
        
        pref.setValue(email.text, forKey: "email")
        pref.setValue(pass.text, forKey: "password")
        self.performSegueWithIdentifier("agreeSegue", sender: sender)
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
